class Trainee < User
  belongs_to :trainer, class_name: 'Trainer', optional: true
  has_and_belongs_to_many :workouts, join_table: 'workouts_trainees'

  validates :expertise_area, :trainer_id, presence: true, if: :persisted?

  def api_attributes
    attributes.slice('id', 'email', 'first_name', 'last_name')
  end

  def expertise_area
    trainer&.expertise_area
  end
end
