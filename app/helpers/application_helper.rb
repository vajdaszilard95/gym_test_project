module ApplicationHelper
  def format_duration(duration)
    hours, minutes = duration / 60, duration % 60
    [hours, minutes].map { |i| i.to_s.rjust(2, '0') }.join(':')
  end
end
