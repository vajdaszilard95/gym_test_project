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
                (link_to 'Delete', workout_path(workout), method: :delete if can?(:destroy, workout)),
              ].join(' ').html_safe
            else
              workout.send(column)
            end
          end
        end
    }
  end
end
