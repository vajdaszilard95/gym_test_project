class Ability
  include CanCan::Ability

  def initialize(user)
    case user.type
    when 'Trainer'
      can :manage, :all

      cannot :manage, [Workout, Trainee, Trainer]

      can :manage, Workout, creator_id: user.id

      can [:read, :assign_workouts], Trainee, trainer_id: user.id
    when 'Trainee'
      can :read, :all

      cannot :manage, [Workout, Trainee]

      can :read, Workout, trainees: { id: user.id }, creator_id: user.trainer_id, state: 'published'

      can :choose, Trainer
    end
  end
end
