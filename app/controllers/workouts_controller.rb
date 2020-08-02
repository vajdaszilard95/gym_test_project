class WorkoutsController < AuthorizedController
  load_and_authorize_resource

  def index
    @workouts = current_user.visible_workouts
    @workouts = @workouts.includes(:trainees) if Workout::PERMITTED_COLUMNS[current_user.type].include?('trainees')
  end

  def new
  end

  def create
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
