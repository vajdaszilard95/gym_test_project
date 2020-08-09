FactoryBot.define do
  factory :trainee do
    first_name { 'Trainee' }
    sequence(:last_name) { |i| "#{i}" }
    sequence(:email) { |i| "trainee_#{i}@gym.test" }
    password { '123456' }
  end
end
