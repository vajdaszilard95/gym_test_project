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
      can :read, Workout, creator_id: user.trainer_id if user.trainer_id.present?
    end
  end
end
