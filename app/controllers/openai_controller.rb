class OpenaiController < ApplicationController
  def index
    if params[:query]
      @response = OpenaiService.new(params[:query]).call
    end
  rescue => e
    @error = e.message
  end
end
