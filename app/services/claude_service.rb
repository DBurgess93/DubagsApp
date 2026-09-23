class ClaudeService
  MODEL = :"claude-opus-5"
  # Heroku cuts off requests at 30 seconds, so give up before then and show our own message.
  TIMEOUT_SECONDS = 25

  class Error < StandardError; end

  def initialize
    # No retries: a retry would push the request past Heroku's 30 second limit.
    @client = Anthropic::Client.new(api_key: ENV['ANTHROPIC_API_KEY'], timeout: TIMEOUT_SECONDS, max_retries: 0)
  end

  def call_text(query)
    raise ArgumentError, 'Query cannot be blank' if query.blank?

    message = @client.messages.create(
      model: MODEL,
      max_tokens: 4000,
      # A short scene doesn't need deep thinking; low effort makes responses much faster.
      output_config: { effort: :low },
      messages: [{ role: 'user', content: query }]
    )
    raise Error, 'Claude declined to write this scene. Try different selections.' if message.stop_reason == :refusal

    message.content.select { |block| block.type == :text }.map(&:text).join
  rescue Anthropic::Errors::APITimeoutError
    raise Error, 'Claude took too long to write the scene. Please try again.'
  rescue Anthropic::Errors::RateLimitError, Anthropic::Errors::InternalServerError
    raise Error, 'Claude is busy right now. Please try again in a minute.'
  rescue Anthropic::Errors::APIError => e
    Rails.logger.error("Claude API error: #{e.class}: #{e.message}")
    raise Error, 'Something went wrong writing the script. Please try again.'
  end
end
