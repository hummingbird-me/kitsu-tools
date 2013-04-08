class Ability
  include CanCan::Ability

  def initialize(user)
    if user.nil?
      # Guest permissions
    elsif user.admin?
      # Admin permissions
      can :manage, :all
    else
      # Regular user permissions
    end
  end
end
