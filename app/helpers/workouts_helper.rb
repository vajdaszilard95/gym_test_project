module WorkoutsHelper
  def workouts_table_data(workouts, user)
    columns = Workout::PERMITTED_COLUMNS[user.type]
    {
      columns:
        columns.map(&:humanize),
      rows:
        workouts.map do |workout|
          columns.map do |column|
            case column
            when 'duration'
              format_duration(workout.duration)
            when 'trainees'
              workout.trainees.size
            when 'actions'
              [
                (link_to 'View', workout_path(workout) if can?(:show, workout)),
                (link_to 'Edit', edit_workout_path(workout) if can?(:edit, workout)),
                (link_to 'Delete', workout_path(workout), method: :delete, data: { confirm: 'Are you sure?' } if can?(:destroy, workout)),
              ].join(' ').html_safe
            else
              workout.send(column)
            end
          end
        end
    }
  end

  def workout_exercises_table_data(workout)
    columns = %w(name duration)
    {
      columns:
        columns.map(&:humanize),
      rows:
        workout.exercises.map do |workout|
          columns.map do |column|
            case column
            when 'duration'
              format_duration(workout.duration)
            else
              workout.send(column)
            end
          end
        end << ['<b class="float-right">Total duration:</b>', "<b>#{format_duration(workout.exercises.map(&:duration).sum)}</b>"].map(&:html_safe)
    }
  end
end
