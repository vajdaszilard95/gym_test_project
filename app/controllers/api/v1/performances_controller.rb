class Api::V1::PerformancesController < Api::V1::AuthorizedController
  swagger_controller :performances, 'Performances'

  swagger_api :index do
    summary 'Get list of Performances'
    param :query, :trainee_id, :string, :optional, 'Trainee ID (for Trainers only)'
    param :query, :start_date, :string, :optional, 'Start date'
    param :query, :end_date, :string, :optional, 'End date'
  end

  def index
    filters = {
      start_date: params.fetch(:start_date, 1.month.ago),
      end_date: params.fetch(:end_date, Time.now)
    }

    performances = trainee.performances.where('performed_at >= :start_date AND performed_at <= :end_date', filters)
    performances = performances.where(workout_id: current_user.workout_ids) if current_user.is_a?(Trainer)

    render json: { performances: performances }
  end

  private

  def trainee
    @trainee ||=
      if current_user.is_a?(Trainee)
        current_user
      elsif current_user.is_a?(Trainer)
        current_user.trainees.find(params[:trainee_id])
      end
  end
end
