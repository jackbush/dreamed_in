class DreamsController < ApplicationController
  def index
    @dream = Dream.new
    @dreams = Dream.all
    respond_to do |format|
      format.html
      format.json { render json: @dreams }
    end
  end

  def show
    @dream = Dream.find(params[:id])
  end

  def create
    binding.pry
    @dream = Dream.create(dream_params)
    redirect_to root_path
    # respond_to do |format|
    #   format.html redirect here?
    #   format.json { render json: @dreams }
    # end
  end

  private
  def dream_params
    params.require(:dream).permit(:title, :description, :location_lat, :location_long, :dream_image, :daydream)
  end
end
