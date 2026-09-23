class ClaudeService
  MODEL = :"claude-opus-5"

  def initialize
    @client = Anthropic::Client.new(api_key: ENV['ANTHROPIC_API_KEY'])
  end

  def call_text(query)
    raise ArgumentError, 'Query cannot be blank' if query.blank?

    message = @client.messages.create(
      model: MODEL,
      max_tokens: 16000,
      messages: [{ role: 'user', content: query }]
    )
    raise 'Claude declined to write this scene. Try different selections.' if message.stop_reason == :refusal

    message.content.select { |block| block.type == :text }.map(&:text).join
  end
end
