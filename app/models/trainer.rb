class Trainer < User
  has_many :workouts, foreign_key: 'creator_id', dependent: :destroy
  has_many :trainees

  def self.by_expertise_area(expertise_area = nil)
    collection = select([:id, :first_name, :last_name, :expertise_area])
    collection = collection.where(expertise_area: expertise_area) if expertise_area.present?
    collection.group_by(&:expertise_area)
  end
end
