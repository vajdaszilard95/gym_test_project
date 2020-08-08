class User < ApplicationRecord
  acts_as_token_authenticatable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :type, presence: true
  validates :first_name, :last_name, presence: true, if: :persisted?

  def initialize(*args)
    super

    self.type ||= 'Trainee'
  end

  def api_attributes
    attributes.slice('id', 'email', 'first_name', 'last_name')
  end

  def full_name
    "#{first_name} #{last_name}"
  end
  alias_method :to_s, :full_name

  def auth_token
    update_column :authentication_token, Devise.friendly_token if authentication_token.blank?
    authentication_token
  end
end
