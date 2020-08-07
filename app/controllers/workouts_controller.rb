class WorkoutsController < AuthorizedController
  load_and_authorize_resource

  def index
    @workouts = @workouts.includes(:trainees) if Workout::PERMITTED_COLUMNS[current_user.type].include?('trainees')
  end

  def create
    @workout = Workout.create(workout_params)
    if @workout.valid?
      redirect_to :workouts, flash: { notice: 'Workout created succesfully.' }
    else
      render :new
    end
  end

  def update
    if @workout.update(workout_params)
      redirect_to :workouts, flash: { notice: 'Workout updated succesfully.' }
    else
      render :edit
    end
  end

  def destroy
    @workout.destroy
    redirect_to :workouts, flash: { notice: 'Workout deleted succesfully.' }
  end

  private

  def workout_params
    creator = current_user if current_user.is_a?(Trainer)
    params.require(:workout).permit(:name, :state, exercise_ids: [], trainee_ids: []).merge(creator: creator)
  end
end
