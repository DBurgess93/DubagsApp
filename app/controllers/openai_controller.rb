class OpenaiController < ApplicationController
  before_action :set_select_options, only: [:index, :create]
  def index
    if params[:query]
      service = OpenaiService.new

      text_response = service.call_text(params[:query])
      @response = text_response
    end
  rescue => e
    @error = e.message
  end

  def create
    genre = params[:genre]
    location = params[:location]
    characters = params[:characters].split(',').map(&:strip)

    query_template = "write a script for a movie scene that goes for no more than 1000 words. The movie is a %{genre}, set in %{location}, involving the characters %{characters}. do not include any narration, only briefly describe the scene. start each characters line with their name in capital letters, then ':' after. Start and finish each narration or description with '*'"

    query = query_template % {genre: genre, location: location, characters: characters.join(", ")}
    @response = OpenaiService.new.call_text(query)

    respond_to do |format|
      format.html { redirect_to openai_path(query: @response), notice: 'Script generated successfully.' }
    end
  end

  def set_select_options
    @genres = [
      "Comedy",
      "Horror",
      "Romance",
      "Action",
      "Sci-Fi",
      "Fantasy",
      "Soap Opera"
    ]

    @locations = [
      "Australia",
      "United Kingdom",
      "Europe",
      "Sahara Desert",
      "Amazon Jungle",
      "Space",
      "Mars",
      "Stranded Island"
    ]
  end
end
