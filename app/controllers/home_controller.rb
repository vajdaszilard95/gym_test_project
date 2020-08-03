class HomeController < ApplicationController
  before_action :redirect_if_authorized!

  private

  def redirect_if_authorized!
    if user_signed_in?
      redirect_path =
        if current_user.is_a?(Trainee) && current_user.trainer_id.nil?
          # new trainees are redirected to their profile page to select a trainer
          edit_profile_path
        else
          # the other users are redirected to the workouts page
          workouts_path
        end

      redirect_to redirect_path
    end
  end
end
