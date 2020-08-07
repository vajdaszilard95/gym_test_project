class Api::V1::WorkoutsController < Api::V1::AuthorizedController
  load_and_authorize_resource

  swagger_controller :workouts, 'Workouts'

  swagger_api :index do
    summary 'Get list of Workouts'
  end

  def index
    @workouts = @workouts.includes(:exercises)
    @workouts = @workouts.includes(:trainees) if Workout::PERMITTED_COLUMNS[current_user.type].include?('trainees')
    render json: { workouts: @workouts.map { |workout| workout.api_attributes(current_user) } }
  end

  swagger_api :create do
    summary 'Create Workout'
    param :form, :name, :string, :optional, 'Name'
    param :form, :state, :string, :optional, 'State', enum: WORKOUT_STATES
    param :form, :'exercise_ids[]', :array, :optional, 'Exercises'
    param :form, :'trainee_ids[]', :array, :optional, 'Trainees'
    response :forbidden
  end

  def create
    @workout = Workout.create(workout_params)
    if @workout.valid?
      render json: { message: 'Workout created succesfully.' }
    else
      render json: { error: @workout.errors.messages }
    end
  end

  swagger_api :update do
    summary 'Update Workout'
    param :path, :id, :string, :optional, 'ID'
    param :form, :name, :string, :optional, 'Name'
    param :form, :state, :string, :optional, 'State', enum: WORKOUT_STATES
    param :form, :'exercise_ids[]', :array, :optional, 'Exercises'
    param :form, :'trainee_ids[]', :array, :optional, 'Trainees'
    response :forbidden
  end

  def update
    if @workout.update(workout_params)
      render json: { message: 'Workout updated succesfully.' }
    else
      render json: { error: @workout.errors.messages }
    end
  end

  swagger_api :destroy do
    summary 'Delete Workout'
    param :path, :id, :string, :optional, 'ID'
    response :forbidden
  end

  def destroy
    @workout.destroy
    render json: { message: 'Workout deleted succesfully.' }
  end

  private

  def workout_params
    creator = current_user if current_user.is_a?(Trainer)
    params.permit(:name, :state, exercise_ids: [], trainee_ids: []).merge(creator: creator)
  end
end
