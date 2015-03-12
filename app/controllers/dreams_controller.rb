class DreamsController < ApplicationController
  def index
    @dream = Dream.new
    @dreams = Dream.all
  end

  def show
    @dream = Dream.find(params[:id])
  end

  def create
    binding.pry
    @dream = Dream.create(dream_params)
    redirect_to dreams_path
  end

  private
  def dream_params
    params.require(:dream).permit(:title, :description, :dream_image, :daydream)
  end
end
