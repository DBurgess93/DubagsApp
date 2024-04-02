class OpenaiController < ApplicationController
  def index
    @prompts = [
      {
        title: "Comedy",
        text: "write a script for a movie scene that goes for no more than 1000 words. the movie is an action comedy involving a good guy named BRETT, and sidekick named TERRY and a bad guy name WOBOBO. make it funny. do not include any narration, only briefly describe the scene. start each characters line with their name in capital letters, then '::' after. start and finish each narration or description with '*'"
      },
      {
        title: "Drama",
        text: "write a script for a movie scene that goes for no more than 1000 words. the movie is a drama involving a man named JAMES, a friend named LISA and a woman name ALICE. make it emotional. do not include any narration, only briefly describe the scene. start each characters line with their name in capital letters, then '::' after. start and finish each narration or description with '*'"
      },
      {
        title: "Horror",
        text: "write a script for a movie scene that goes for no more than 1000 words. the movie is a horror involving a Woman name JESS, a man named BOB, and another woman named LUCY. make it scary. do not include any narration, only briefly describe the scene. start each characters line with their name in capital letters, then '::' after. start and finish each narration or description with '*'"
      },
      {
        title: "Romance",
        text: "write a script for a movie scene that goes for no more than 1000 words. the movie is a romance involving a Woman name BELLA and a woman named TAYLA. make it romantic. do not include any narration, only briefly describe the scene. start each characters line with their name in capital letters, then '::' after. start and finish each narration or description with '*'"
      }
    ]
    if params[:query]
      service = OpenaiService.new

      text_response = service.call_text(params[:query])
      @response = text_response
      # @image_url = service.generate_image(text_response) if text_response.present?
    end
  rescue => e
    @error = e.message
  end
end
