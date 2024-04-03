class OpenaiService
  include HTTParty
  attr_reader :api_url, :options

  def initialize
    @api_url = 'https://api.openai.com/v1'
    @options = {
      headers: {
        'Content-Type': 'application/json',
        'Authorization' => "Bearer #{ENV['OPENAI_API_KEY']}"
      }
    }
  end

  def call_text(query)
    raise ArgumentError, 'Query cannot be blank' if query.blank?

    body = {
      model: 'gpt-4',
      messages: [{ role: 'user', content: query }]
    }
    response = self.class.post("#{@api_url}/chat/completions", body: body.to_json, headers: @options[:headers], timeout: 500)
    raise response['error']['message'] unless response.code == 200
    response['choices'][0]['message']['content']
  end
end
