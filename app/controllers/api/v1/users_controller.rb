class Api::V1::UsersController < Api::V1::BaseController
  swagger_controller :users, 'Users'

  swagger_api :sign_in do
    summary 'Get Authentication Token'
    param :form, :user_email, :string, :optional, 'Email address'
    param :form, :user_password, :string, :optional, 'Password'
    response :unauthorized
  end

  def sign_in
    user = User.find_by_email(params[:user_email])
    if user&.valid_password?(params[:user_password])
      render json: { user_token: user.auth_token }
    else
      render json: { error: 'Invalid credentials' }, status: :unauthorized
    end
  end
end
