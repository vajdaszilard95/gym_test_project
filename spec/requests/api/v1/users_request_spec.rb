require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  describe '#sign_in' do
    context 'invalid credentials' do
      it 'returns error message' do
        post api_v1_users_sign_in_path, params: { format: :json }
        expect(response).to have_http_status(:unauthorized)

        response_json = JSON.parse(response.body)
        expect(response_json['error']).to eq('Invalid credentials')
      end
    end

    context 'valid credentials' do
      let(:user) { create(:trainer) }

      it 'returns the access token' do
        post api_v1_users_sign_in_path, params: { user_email: user.email, user_password: '123456', format: :json }
        expect(response).to have_http_status(:success)

        response_json = JSON.parse(response.body)
        expect(response_json['user_token']).to eq(user.reload.auth_token)
      end
    end
  end
end
