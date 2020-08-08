class Api::V1::TraineesController < Api::V1::AuthorizedController
  load_and_authorize_resource

  swagger_controller :trainees, 'Trainees'

  swagger_api :index do
    summary 'Get list of Trainees'
  end

  def index
    render json: { trainees: @trainees.map(&:api_attributes) }
  end

  swagger_api :assign_workouts do
    summary 'Assign multiple Workouts for a Trainee'
    param :path, :id, :string, :optional, 'ID'
    param :form, :'workout_ids[]', :array, :optional, 'Workout IDs'
  end

  def assign_workouts
    # we keep workouts from older trainers in case that the trainee switches back the trainer
    # and assign only the current trainer`s workouts
    workout_ids = @trainee.workout_ids - current_user.workout_ids + (current_user.workout_ids & params[:workout_ids].to_a.map(&:to_i))

    if @trainee.update(workout_ids: workout_ids)
      render json: { message: 'Workouts assigned successfully for trainee.' }
    else
      render json: { error: @trainee.errors.messages }, status: :unprocessable_entity
    end
  end
end
