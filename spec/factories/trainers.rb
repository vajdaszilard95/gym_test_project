FactoryBot.define do
  factory :trainer do
    first_name { 'Trainer' }
    sequence(:last_name) { |i| "#{i}" }
    sequence(:email) { |i| "trainer_#{i}@gym.test" }
    password { '123456' }
    expertise_area { 'yoga' }
  end
end
