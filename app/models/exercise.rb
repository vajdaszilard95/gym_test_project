class Exercise < ApplicationRecord
  def self.options_for_select
    all.map do |exercise|
      ["#{exercise.name} (#{exercise.duration} mins)", exercise.id]
    end
  end
end
