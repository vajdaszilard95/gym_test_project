class Performance < ApplicationRecord
  belongs_to :trainee
  belongs_to :workout

  serialize :results, Hash
  # results are stored in the following format for each exercise:
  # {
  #   1 => { 'exercise_name' => 'Exercise 1', 'pulse_average' => 79 },
  #   2 => { 'exercise_name' => 'Exercise 2', 'pulse_average' => 80 }
  # }

  validates :results, :performed_at, presence: true
  validate :validate_results

  before_save :set_results_data

  private

  def validate_results
    return if errors[:results].any?

    workout&.exercises.to_a.each do |exercise|
      errors.add(:results, "are missing for #{exercise.name}") and return unless results.key?(exercise.id)
      errors.add(:results, "for #{exercise.name} does not contain the pulse average") and return unless results[exercise.id]['pulse_average']
      errors.add(:results, "for #{exercise.name} contains invalid pulse average") and return unless results[exercise.id]['pulse_average'].is_a?(Integer)
    end
  end

  def set_results_data
    workout.exercises.each do |exercise|
      results[exercise.id]['exercise_name'] = exercise.name
    end
  end
end
