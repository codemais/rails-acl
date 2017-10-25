class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.admin?
      can :manage, :all
    else
      Permission.all.each do |p|
        if defined? p.app_module.module
          can get_action(p), p.app_module.module.constantize
        end
      end
    end
  end

  private

  def get_action(permission)
    permission.actions.collect(&:key)
  end
end
