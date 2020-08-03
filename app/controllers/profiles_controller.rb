class ProfilesController < AuthorizedController
  before_action :load_trainers

  def edit
  end

  def update
    current_user.update(user_params)
    render :edit
  end

  private

  def user_params
    params.require(current_user.type.underscore).permit(:first_name, :last_name, :trainer_id)
  end

  def load_trainers
    @grouped_trainers = Trainer.select([:id, :first_name, :last_name, :expertise_area]).group_by(&:expertise_area)
  end
end
