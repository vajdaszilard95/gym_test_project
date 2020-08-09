FactoryBot.define do
  factory :workout do
    sequence(:name) { |i| "Workout #{i}" }
    state { 'published' }
  end
end
