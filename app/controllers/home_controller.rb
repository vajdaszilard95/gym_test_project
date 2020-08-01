class HomeController < ApplicationController
  before_action :redirect_if_authorized!

  def index
  end

  private

  def redirect_if_authorized!
    redirect_to workouts_path if user_signed_in?
  end
end
