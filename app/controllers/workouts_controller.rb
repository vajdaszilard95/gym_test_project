class WorkoutsController < AuthorizedController
  def index
    @workouts = current_user.visible_workouts
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
