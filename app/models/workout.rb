class Workout < ApplicationRecord
  has_and_belongs_to_many :exercises
  belongs_to :creator, class_name: 'Trainer'
  has_and_belongs_to_many :trainees, join_table: 'workouts_trainees'

  validates :name, :state, :exercises, presence: true
  validates_inclusion_of :state, in: WORKOUT_STATES, if: :state?

  before_save :set_duration

  PERMITTED_COLUMNS = {
    'Trainer' => %w(name duration trainees state actions),
    'Trainee' => %w(name duration actions),
  }.freeze

  def api_attributes(user)
    result = attributes.slice('id', *PERMITTED_COLUMNS[user.type])

    result['formatted_duration'] = ApplicationController.helpers.format_duration(duration) if result.key?('duration')
    result['exercises'] = exercises.map(&:api_attributes)
    result['trainees'] = trainees.map(&:api_attributes) if PERMITTED_COLUMNS[user.type].include?('trainees')

    result
  end

  private

  def set_duration
    self.duration = exercises.map(&:duration).sum
  end
end
