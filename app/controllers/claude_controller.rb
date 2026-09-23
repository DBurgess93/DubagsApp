class ClaudeController < ApplicationController
  before_action :set_select_options, only: [:index, :create]
  def index
  end

  def create
    @genre = params[:genre]
    @location = params[:location]
    @characters = params[:characters].to_s.split(',').map(&:strip).reject(&:blank?).map(&:titleize)
    @timeline = params[:timeline]
    @tone = params[:tone]

    if @characters.empty?
      @error = 'Please add at least one character.'
      return render :index
    end

    query_template = "Write a script for a movie scene that goes for no more than 300 words. Briefly describe the scene at the very start but do not include any narration throughout the script, the main body of the script should only include the characters lines. The scene should follow these guidelines:
    Genre: %{genre}
    Characters: %{characters}
    Location: %{location}
    Timeline: %{timeline}
    Characters attitude/language: %{tone}
    Do not include things like 'Dan and Dillon Laugh', and do not include any actions or behaviours of the characters, dialogue only. Do not make it too friendly. The script is meant for an adult audience."

    query = query_template % {genre: @genre, location: @location, characters: @characters.join(", "), timeline: @timeline, tone: @tone}
    @response = ClaudeService.new.call_text(query)

    render :index
  rescue ClaudeService::Error => e
    @error = e.message
    render :index
  end

  private

  def set_select_options
    @genres = [
      "Fantasy",
      "Comedy",
      "Horror",
      "Romance",
      "Action",
      "Sci-Fi",
      "Soap Opera",
      "Anime"
    ]

    @locations = [
      "Middle Earth",
      "Space Station",
      "Haunted House",
      "Jungle",
      "Desert",
      "Ancient Rome",
      "Medieval Castle",
      "Mars",
      "Post-Apocalyptic City",
      "Wild West",
      "Pirate Ship",
      "Alien Planet",
      "Futuristic City",
    ]

    @timelines = [
      "Third Age Middle Earth",
      "Golden Age of Piracy",
      "Present Day",
      "Future",
      "Medieval",
      "Victorian",
      "Ancient Rome",
      "Cave Man Times",
      "Post-Apocalyptic"
    ]

    @tones = [
      "Dorky",
      "Posh",
      "Gangster",
      "Anime",
      "Goth",
      "Hippie",
      "Emo",
      "Cowboy",
      "Pirate",
      "Robot",
    ]
  end
end
