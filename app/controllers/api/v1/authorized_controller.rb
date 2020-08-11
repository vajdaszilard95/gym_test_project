class Api::V1::AuthorizedController < Api::V1::BaseController
  acts_as_token_authentication_handler_for User

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { render json: { error: exception.message }, status: :forbidden }
    end
  end

  class << self
    Swagger::Docs::Generator::set_real_methods

    def inherited(subclass)
      super

      subclass.class_eval do
        setup_basic_api_documentation
      end
    end

    private

    def setup_basic_api_documentation
      [:index, :create, :update, :destroy, :choose, :assign_workouts].each do |api_action|
        swagger_api api_action do
          param :header, 'X-User-Email', :string, :optional, 'User Email'
          param :header, 'X-User-Token', :string, :optional, 'Authentication token'
          response :unauthorized
        end
      end
    end
  end
end
