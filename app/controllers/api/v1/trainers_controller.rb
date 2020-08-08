class Api::V1::TrainersController < Api::V1::AuthorizedController
  authorize_resource

  swagger_controller :trainers, 'Trainers'

  swagger_api :index do
    summary 'Get list of Trainers'
    param :query, :expertise_area, :string, :optional, 'Area of Expertise'
  end

  def index
    grouped_trainers = Trainer.by_expertise_area(params[:expertise_area]) if params[:expertise_area].present?

    if grouped_trainers.present?
      render json: { trainers: grouped_trainers[params[:expertise_area]].map(&:api_attributes) }
    else
      render json: {
        expertise_areas: Trainer.distinct.pluck(:expertise_area),
        error: 'Please choose Area of Expertise.'
      }, status: :unprocessable_entity
    end
  end

  swagger_api :choose do
    summary 'Choose Trainer'
    param :form, :trainer_id, :integer, :optional, 'Trainer ID'
  end

  def choose
    if current_user.update(trainer_id: params[:trainer_id])
      render json: { message: 'Trainer chosen successfully.' }
    else
      render json: { error: 'Trainer ID is invalid.' }, status: :unprocessable_entity
    end
  end
end
