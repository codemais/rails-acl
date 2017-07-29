class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.is_admin?
      can :manage, :all
    else
      Permission.all.each do |p|
        can p.actions.collect{|action| action.to_sym}, p.app_module.module.constantize if defined? p.app_module.module
      end
    end
  end
end
