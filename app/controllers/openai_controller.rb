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
    @genre = params[:genre]
    @location = params[:location]
    @characters = params[:characters].split(' ').map(&:strip).map { |name| name.titleize }
    @villain = params[:villain].split(' ').map(&:strip).map { |name| name.titleize }
    query_template = "write a script for a movie scene that goes for no more than 1000 words. The movie is a %{genre}, set in %{location}, involving the characters %{characters}, and a villain named %{villain}. do not include any narration, only briefly describe the scene (no more then 10 words per line). start each characters line with their name in capital letters, then ':' after. Start and finish each narration or description with '*'"

      # Example query:
      # Write a script for a movie scene that goes for no more than 300 words. Briefly describe the scene at the very start but do not include any narration throughout the script, the main body of the script should only include the characters lines. The scene should follow these guidelines:
      #   Genre: Action/Comedy
      #   Antagonist: Adam
      #   Support Role: Dillon
      #   Villain: Dan
      #   Location: Space
      #   Timeline: Cave man era

      #   Do not include things like "Dan and Dillon Laugh", and do not include any actions or behaviours of the characters, dialogue only. Make the script really funny but avoid only using jokes that mock the villain.


    query = query_template % {genre: @genre, location: @location, characters: @characters.join(", "), villain: @villain.join(", ")}
    @response = OpenaiService.new.call_text(query)

    render :index
  end

  def set_select_options
    @genres = [
      "Comedy",
      "Horror",
      "Romance",
      "Action",
      "Sci-Fi",
      "Fantasy",
      "Soap Opera",
    ]

    @locations = [
      "Australia",
      "Beach",
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
