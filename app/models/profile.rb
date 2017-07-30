class Profile < ApplicationRecord
  has_many :permissions, :dependent => :delete_all

  def has_action(app_module_id, action)
    permissions = self.permissions.where(app_module_id: app_module_id)
    return permissions.empty? ? false : permissions.first.actions.include?(action)
  end

  def save_permissions params
    self.permissions.delete_all
    permissions = params.empty? ? [] : params
    permissions.each do |i, permission|
      app_module_id = permission[:app_module]
      actions = []
      permission[:actions].each do |j, action|
        actions.push(:new) if action[:action].to_sym == :create
        actions.push(:edit) if action[:action].to_sym == :update
        actions.push(action[:action])
      end if permission[:actions].present?
      self.permissions << Permission.new(app_module_id: app_module_id, actions: actions)
    end
  end

end
