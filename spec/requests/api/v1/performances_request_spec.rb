require 'rails_helper'

RSpec.describe "Api::V1::Performances", type: :request do
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

  before do
    trainees.each do |trainee|
      trainee.workouts.each do |workout|
        [1, 3, 5].each do |i|
          trainee.performances.create!(
            workout: workout,
            results: workout.exercises.map { |exercise| [exercise.id, { 'pulse_average' => rand(65..95) }] }.to_h,
            performed_at: i.weeks.ago
          )
        end
      end
    end
  end

  describe '#index' do
    context 'as trainer' do
      it 'returns list of his trainees performances in the last month' do
        get api_v1_performances_path, headers: login_headers(trainers[0]), params: { trainee_id: trainees[0].id, format: :json }
        expect(response).to have_http_status(:success)

        response_json = JSON.parse(response.body)
        expect(response_json['performances'].count).to eq(4)
      end

      it 'returns list of his trainees performances in the last 2 months' do
        get api_v1_performances_path, headers: login_headers(trainers[0]), params: { trainee_id: trainees[0].id, start_date: 2.months.ago, format: :json }
        expect(response).to have_http_status(:success)

        response_json = JSON.parse(response.body)
        expect(response_json['performances'].count).to eq(6)
      end

      context 'invalid trainee' do
        it 'returns error' do
          get api_v1_performances_path, headers: login_headers(trainers[0]), params: { trainee_id: trainees[1].id, format: :json }
          expect(response).to have_http_status(:unprocessable_entity)

          response_json = JSON.parse(response.body)
          expect(response_json['error']).to eq('Exception occured.')
        end
      end
    end

    context 'as trainee' do
      it 'returns list of his trainees performances in the last month' do
        get api_v1_performances_path, headers: login_headers(trainees[0]), params: { format: :json }
        expect(response).to have_http_status(:success)

        response_json = JSON.parse(response.body)
        expect(response_json['performances'].count).to eq(4)
      end

      it 'returns list of his trainees performances in the last 2 months' do
        get api_v1_performances_path, headers: login_headers(trainees[0]), params: { start_date: 2.months.ago, format: :json }
        expect(response).to have_http_status(:success)

        response_json = JSON.parse(response.body)
        expect(response_json['performances'].count).to eq(6)
      end

    end
  end
end
