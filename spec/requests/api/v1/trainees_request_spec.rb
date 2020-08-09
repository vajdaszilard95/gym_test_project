require 'rails_helper'

RSpec.describe "Api::V1::Trainees", type: :request do
  let(:trainers) { [
    create(:trainer),
    create(:trainer),
  ] }
  let(:trainees) { [
    create(:trainee, trainer: trainers[0]),
    create(:trainee, trainer: trainers[1]),
  ] }
  let(:exercises) { [
    create(:exercise),
  ] }
  let!(:workouts) { [
    create(:workout, creator: trainers[0], trainees: [trainees[0]], exercises: exercises),
    create(:workout, creator: trainers[1], trainees: [trainees[1]], exercises: exercises),
    create(:workout, creator: trainers[1], trainees: [trainees[1]], exercises: exercises, state: 'draft'),
    create(:workout, creator: trainers[0], trainees: [trainees[0]], exercises: exercises, state: 'draft'),
  ] }

  describe '#index' do
    context 'unauthorized' do
      it 'returns error' do
        get api_v1_trainees_path, params: { format: :json }
        expect(response).to have_http_status(:unauthorized)

        response_json = JSON.parse(response.body)
        expect(response_json['error']).to eq('You need to sign in or sign up before continuing.')
      end
    end

    context 'as trainer' do
      it 'list of his trainees' do
        get api_v1_trainees_path, headers: login_headers(trainers[0]), params: { format: :json }
        expect(response).to have_http_status(:success)

        response_json = JSON.parse(response.body)
        expect(response_json['trainees'].count).to eq(1)
      end
    end

    context 'as trainee' do
      it 'returns error' do
        get api_v1_trainees_path, headers: login_headers(trainees[0]), params: { format: :json }
        expect(response).to have_http_status(:forbidden)

        response_json = JSON.parse(response.body)
        expect(response_json['error']).to eq('You are not authorized to access this page.')
      end
    end
  end

  describe '#assign_workouts' do
    context 'as trainer' do
      it 'assigns only the owned workouts for trainee' do
        post assign_workouts_api_v1_trainee_path(trainees[0]), headers: login_headers(trainers[0]), params: { workout_ids: workouts.map(&:id), format: :json }
        expect(response).to have_http_status(:success)

        response_json = JSON.parse(response.body)
        expect(trainees[0].reload.workouts).to match_array(trainers[0].workouts)
        expect(response_json['message']).to eq('Workouts assigned successfully for trainee.')
      end

      context 'invalid trainee' do
        it 'returns error' do
          post assign_workouts_api_v1_trainee_path(trainees[1]), headers: login_headers(trainers[0]), params: { format: :json }
          expect(response).to have_http_status(:forbidden)

          response_json = JSON.parse(response.body)
          expect(response_json['error']).to eq('You are not authorized to access this page.')
        end
      end
    end

    context 'as trainee' do
      it 'returns error' do
        post assign_workouts_api_v1_trainee_path(trainees[0]), headers: login_headers(trainees[0]), params: { format: :json }
        expect(response).to have_http_status(:forbidden)

        response_json = JSON.parse(response.body)
        expect(response_json['error']).to eq('You are not authorized to access this page.')
      end
    end
  end
end
