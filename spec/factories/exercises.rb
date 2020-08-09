FactoryBot.define do
  factory :exercise do
    sequence(:name) { |i| "Exercise #{i}" }
    duration { rand(1..6) * 5 }
  end
end
