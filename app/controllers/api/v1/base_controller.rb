class Api::V1::BaseController < ActionController::Base
  skip_before_action :verify_authenticity_token

  rescue_from StandardError do |exception|
    respond_to do |format|
      format.json do
        render json: { error: Rails.env.development? ? exception.message : 'Exception occured.' }, status: :unprocessable_entity 
      end
    end
  end
end
