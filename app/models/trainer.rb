class Trainer < User
  has_many :workouts, foreign_key: 'creator_id'
  has_many :trainees

  def visible_workouts
    workouts
  end
end
