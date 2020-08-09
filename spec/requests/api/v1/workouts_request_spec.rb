require 'rails_helper'

RSpec.describe "Api::V1::Workouts", type: :request do
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
  let(:params) { {
    name: 'My Workout',
    state: 'published',
    exercise_ids: exercises.map(&:id),
    trainee_ids: trainees[0].id,
    format: :json,
  } }

  describe '#index' do
    context 'unauthorized' do
      it 'returns error' do
        get api_v1_workouts_path, params: { format: :json }
        expect(response).to have_http_status(:unauthorized)

        response_json = JSON.parse(response.body)
        expect(response_json['error']).to eq('You need to sign in or sign up before continuing.')
      end
    end

    context 'as trainer' do
      it 'returns a list of his workouts' do
        get api_v1_workouts_path, headers: login_headers(trainers[0]), params: { format: :json }
        expect(response).to have_http_status(:success)

        response_json = JSON.parse(response.body)
        expect(response_json['workouts'].count).to eq(2)
      end
    end

    context 'as trainee' do
      it 'returns a list of his workouts' do
        get api_v1_workouts_path, headers: login_headers(trainees[1]), params: { format: :json }
        expect(response).to have_http_status(:success)

        response_json = JSON.parse(response.body)
        expect(response_json['workouts'].count).to eq(1)
      end
    end
  end

  describe '#create' do
    context 'as trainer' do
      it 'creates a workout' do
        post api_v1_workouts_path, headers: login_headers(trainers[0]), params: params
        expect(response).to have_http_status(:success)

        response_json = JSON.parse(response.body)
        expect(response_json['message']).to eq('Workout created succesfully.')
      end
    end

    context 'as trainee' do
      it 'returns error' do
        post api_v1_workouts_path, headers: login_headers(trainees[1]), params: params
        expect(response).to have_http_status(:forbidden)

        response_json = JSON.parse(response.body)
        expect(response_json['error']).to eq('You are not authorized to access this page.')
      end
    end
  end

  describe '#update' do
    context 'as trainer' do
      it 'updates the workout' do
        patch api_v1_workout_path(workouts[0]), headers: login_headers(trainers[0]), params: params
        expect(response).to have_http_status(:success)

        response_json = JSON.parse(response.body)
        expect(response_json['message']).to eq('Workout updated succesfully.')
      end

      context 'unowned workout' do
        it 'returns error' do
          patch api_v1_workout_path(workouts[1]), headers: login_headers(trainers[0]), params: params
          expect(response).to have_http_status(:forbidden)

          response_json = JSON.parse(response.body)
          expect(response_json['error']).to eq('You are not authorized to access this page.')
        end
      end
    end

    context 'as trainee' do
      it 'returns error' do
        patch api_v1_workout_path(workouts[0]), headers: login_headers(trainees[1]), params: params
        expect(response).to have_http_status(:forbidden)

        response_json = JSON.parse(response.body)
        expect(response_json['error']).to eq('You are not authorized to access this page.')
      end
    end
  end

  describe '#destroy' do
    context 'as trainer' do
      it 'destroys the workout' do
        delete api_v1_workout_path(workouts[0]), headers: login_headers(trainers[0]), params: params
        expect(response).to have_http_status(:success)

        response_json = JSON.parse(response.body)
        expect(response_json['message']).to eq('Workout deleted succesfully.')
      end

      context 'unowned workout' do
        it 'returns error' do
          delete api_v1_workout_path(workouts[1]), headers: login_headers(trainers[0]), params: params
          expect(response).to have_http_status(:forbidden)

          response_json = JSON.parse(response.body)
          expect(response_json['error']).to eq('You are not authorized to access this page.')
        end
      end
    end

    context 'as trainee' do
      it 'returns error' do
        delete api_v1_workout_path(workouts[0]), headers: login_headers(trainees[1]), params: params
        expect(response).to have_http_status(:forbidden)

        response_json = JSON.parse(response.body)
        expect(response_json['error']).to eq('You are not authorized to access this page.')
      end
    end
  end
end
