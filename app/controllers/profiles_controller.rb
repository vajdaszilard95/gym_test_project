class ProfilesController < AuthorizedController
  before_action :load_trainers

  def edit
  end

  def update
    if current_user.update(user_params)
      redirect_to edit_profile_path, flash: { notice: 'Profile updated successfully.' }
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(current_user.type.underscore).permit(:first_name, :last_name, :trainer_id)
  end

  def load_trainers
    @grouped_trainers = Trainer.by_expertise_area
  end
end
