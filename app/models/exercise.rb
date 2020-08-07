class Exercise < ApplicationRecord
  def self.options_for_select
    all.map do |exercise|
      ["#{exercise.name} (#{exercise.duration} mins)", exercise.id]
    end
  end

  def api_attributes
    result = attributes.slice('id', 'name', 'duration')

    result['formatted_duration'] = ApplicationController.helpers.format_duration(duration) if result.key?('duration')

    result
  end
end
