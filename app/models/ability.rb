class Ability
  include CanCan::Ability

  def initialize(user)
    AppModule.where.not(controller: 'DeviseController').each do |object|
      can object.actions.collect{|action| action.to_sym}, object.class
    end
  end
end
