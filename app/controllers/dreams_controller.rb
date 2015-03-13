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
    redirect_to edit_dream_path @dream
  end

  private
  def dream_params
    params.require(:dream).permit(:title, :description, :dream_image, :daydream)
  end
end
