require 'rails_helper'

RSpec.describe "Api::V1::Trainers", type: :request do
  let(:expertise_areas) { %w(yoga fitness) }
  let!(:trainers) { expertise_areas.each_with_index.flat_map { |expertise_area, i|
    create_list(:trainer, i + 1, expertise_area: expertise_area)
  } }
  let(:trainee) { create(:trainee) }

  describe '#index' do
    context 'unauthorized' do
      it 'returns error' do
        get api_v1_trainers_path, params: { format: :json }
        expect(response).to have_http_status(:unauthorized)

        response_json = JSON.parse(response.body)
        expect(response_json['error']).to eq('You need to sign in or sign up before continuing.')
      end
    end

    context 'as trainer' do
      it 'returns error' do
        get api_v1_trainers_path, headers: login_headers(trainers[0]), params: { format: :json }
        expect(response).to have_http_status(:forbidden)

        response_json = JSON.parse(response.body)
        expect(response_json['error']).to eq('You are not authorized to access this page.')
      end
    end

    context 'as trainee' do
      context 'yoga trainers' do
        it 'returns a list of yoga trainers' do
          get api_v1_trainers_path, headers: login_headers(trainee), params: { expertise_area: 'yoga', format: :json }
          expect(response).to have_http_status(:success)

          response_json = JSON.parse(response.body)
          expect(response_json['trainers'].count).to eq(1)
        end
      end

      context 'fitness trainers' do
        it 'returns a list of yoga trainers' do
          get api_v1_trainers_path, headers: login_headers(trainee), params: { expertise_area: 'fitness', format: :json }
          expect(response).to have_http_status(:success)

          response_json = JSON.parse(response.body)
          expect(response_json['trainers'].count).to eq(2)
        end
      end

      context 'no area of expertise provided' do
        it 'returns a list of expertise areas' do
          get api_v1_trainers_path, headers: login_headers(trainee), params: { format: :json }
          expect(response).to have_http_status(:unprocessable_entity)

          response_json = JSON.parse(response.body)
          expect(response_json['error']).to eq('Please choose Area of Expertise.')
          expect(response_json['expertise_areas']).to match_array(expertise_areas)
        end
      end
    end
  end

  describe '#choose' do
    context 'as trainer' do
      it 'returns error' do
        post choose_api_v1_trainers_path, headers: login_headers(trainers[0]), params: { format: :json }
        expect(response).to have_http_status(:forbidden)

        response_json = JSON.parse(response.body)
        expect(response_json['error']).to eq('You are not authorized to access this page.')
      end
    end

    context 'as trainee' do
      it 'updates the trainer' do
        post choose_api_v1_trainers_path, headers: login_headers(trainee), params: { trainer_id: trainers[0].id, format: :json }
        expect(response).to have_http_status(:success)

        response_json = JSON.parse(response.body)
        expect(response_json['message']).to eq('Trainer chosen successfully.')
      end

      context 'invalid trainer' do
        it 'returns error' do
          post choose_api_v1_trainers_path, headers: login_headers(trainee), params: { format: :json }
          expect(response).to have_http_status(:unprocessable_entity)

          response_json = JSON.parse(response.body)
          expect(response_json['error']).to eq('Trainer ID is invalid.')
        end
      end
    end
  end
end
