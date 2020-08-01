class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :type, presence: true
  validates :first_name, :last_name, :trainer_id, presence: true, if: :persisted?

  def initialize(*args)
    super

    self.type ||= 'Trainee'
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
