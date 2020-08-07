class Trainer < User
  has_many :workouts, foreign_key: 'creator_id', dependent: :destroy
  has_many :trainees
end
