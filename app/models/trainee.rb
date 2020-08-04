class Trainee < User
  belongs_to :trainer, class_name: 'Trainer', optional: true
  has_and_belongs_to_many :workouts, join_table: 'workouts_trainees'

  validates :expertise_area, :trainer_id, presence: true, if: :persisted?

  def visible_workouts
    workouts.where(state: 'published', creator_id: trainer_id)
  end

  def expertise_area
    trainer&.expertise_area
  end
end
