class OpenaiController < ApplicationController
  def index
    if params[:query]
      service = OpenaiService.new

      text_response = service.call_text(params[:query])
      @response = text_response
      @image_url = service.generate_image(text_response) if text_response.present?
    end
  rescue => e
    @error = e.message
  end
end
