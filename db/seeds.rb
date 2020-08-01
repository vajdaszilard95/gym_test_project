# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

PASSWORD = '123456'
EXPERTISE_AREAS = %w(yoga fitness strength)

ApplicationRecord.transaction do
  trainers = EXPERTISE_AREAS.flat_map do |expertise_area|
    1.upto(2).map do |i|
      Trainer.create!(
        first_name: expertise_area.capitalize,
        last_name: "Trainer #{i}",
        email: "#{expertise_area}_trainer_#{i}@gym.test",
        expertise_area: expertise_area,
        password: PASSWORD,
        password_confirmation: PASSWORD,
      )
    end
  end

  trainees = 1.upto(10).map do |i|
    trainer = (trainers.select { |trainer| trainer.trainees.blank? }.presence || trainers).sample
    trainee = Trainee.create!(
      first_name: 'Test',
      last_name: "Trainee #{i}",
      email: "test_trainee_#{i}@gym.test",
      password: PASSWORD,
      password_confirmation: PASSWORD,
      trainer: trainer,
    )
    trainer.trainees << trainee
    trainee
  end

  exercises = 1.upto(10).map do |i|
    Exercise.create!(
      name: "Exercise #{i}",
      duration: ((rand() * 6).to_i + 1) * 5,
    )
  end

  workouts = trainers.flat_map do |trainer|
    1.upto(3).map do |i|
      Workout.create!(
        name: "Workout #{i}",
        creator: trainer,
        state: 'published',
        exercises: exercises.sample((rand() * exercises.size).to_i + 1),
        trainees: trainer.trainees.sample((rand() * trainer.trainees.size).to_i + 1),
      )
    end
  end
end
