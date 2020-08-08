FactoryBot.define do
  factory :trainer do
    first_name { 'Yoga' }
    last_name { 'Trainer 1' }
    email { 'yoga_trainer_1@gym.test' }
    password { '123456' }
    expertise_area { 'yoga' }
  end
end
