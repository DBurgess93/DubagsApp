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

  def generate_image(prompt)
    raise ArgumentError, 'Prompt cannot be blank' if prompt.blank?
    truncated_prompt = prompt.length > 1000 ? prompt[0..999] : prompt

    body = {
      # model: "image-davinci-003",
      prompt: truncated_prompt,
      n: 1,
      size: "1024x1024"
    }
    response = self.class.post("#{@api_url}/images/generations", body: body.to_json, headers: @options[:headers], timeout: 500)
    raise response['error']['message'] unless response.code == 200
    response['data'][0]['url']
  end
end
