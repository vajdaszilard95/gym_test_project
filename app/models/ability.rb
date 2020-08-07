class Ability
  include CanCan::Ability

  def initialize(user)
    case user.type
    when 'Trainer'
      can :manage, :all

      cannot :manage, Workout
      can :manage, Workout, creator_id: user.id
    when 'Trainee'
      can :read, :all

      cannot :manage, Workout
      can :read, Workout, trainees: { id: user.id }, creator_id: user.trainer_id, state: 'published'
    end
  end
end
