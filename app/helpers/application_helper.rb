module ApplicationHelper
  def title
    @title ||= begin
      if devise_controller?
        case "#{controller_name}##{action_name}"
        when 'sessions#new'
          'Log in'
        when 'registrations#new', 'registrations#create'
          'Sign up'
        when 'passwords#new', 'passwords#create'
          'Forgot your password?'
        end
      end
    end
  end

  def menu_items
    result = []
    result << {
      label: 'My Profile',
      path: edit_profile_path,
      active: controller_name == 'profiles'
    } if can?(:index, ProfilesController)
    result << {
      label: 'Workouts',
      path: workouts_path,
      active: controller_name == 'workouts'
    } if can?(:read, Workout)
    result
  end

  def format_duration(duration)
    hours, minutes = duration / 60, duration % 60
    [hours, minutes].map { |i| i.to_s.rjust(2, '0') }.join(':')
  end
end
