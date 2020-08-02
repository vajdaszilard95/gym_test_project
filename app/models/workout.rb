class Workout < ApplicationRecord
  has_and_belongs_to_many :exercises
  belongs_to :creator, class_name: 'Trainer'
  has_and_belongs_to_many :trainees, join_table: 'workouts_trainees'

  before_save :set_duration

  PERMITTED_COLUMNS = {
    'Trainer' => %w(name duration trainees state actions),
    'Trainee' => %w(name duration actions),
  }.freeze

  private

  def set_duration
    self.duration = exercises.map(&:duration).sum
  end
end
