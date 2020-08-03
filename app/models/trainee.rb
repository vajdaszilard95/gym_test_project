class Trainee < User
  belongs_to :trainer, class_name: 'Trainer', optional: true
  has_and_belongs_to_many :workouts, join_table: 'workouts_trainees'

  def visible_workouts
    workouts.where(state: 'published', creator_id: trainer_id)
  end
end
