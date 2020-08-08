namespace :data_generator do
  desc 'Generates workout performances for each trainee/workout'
  task generate_performances: :environment do
    Trainee.includes(workouts: :exercises).each do |trainee|
      trainee.workouts.where(creator_id: trainee.trainer_id).each do |workout|
        performances = trainee.performances.where(workout: workout).order(performed_at: :asc)

        performed_at =
          if performances.last.nil? || performances.last.performed_at < 1.week.ago
            Date.today
          else
            performances.first.performed_at - 1.week
          end

        performance = performances.create!(
          results: workout.exercises.map { |exercise| [exercise.id, { 'pulse_average' => (rand() * 30 + 65).to_i }] }.to_h,
          performed_at: performed_at
        )
      end
    end
  end
end
