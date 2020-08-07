BASE_URL =
  case Rails.env
  when 'development'
    'http://localhost:3000'
  end

WORKOUT_STATES = %w(draft published).freeze
