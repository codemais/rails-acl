class Profile < ApplicationRecord
  has_many :permissions, dependent: :delete_all

  def action?(app_module_id, action)
    permissions = self.permissions.where(app_module_id: app_module_id)
    permissions.empty? ? false : permissions.first.actions.include?(action)
  end

  def save_permissions(params)
    permissions.delete_all
    permissions = params.empty? ? [] : params
    permissions.values.each do |permission|
      next unless permission[:actions].present?
      self.permissions << Permission.new(
        app_module_id: permission[:app_module],
        actions: add_action(permission)
      )
    end
  end

  private

  def add_action(permission)
    actions = []
    permission[:actions].values.each do |action|
      actions.push(:new) if action[:action].to_sym == :create
      actions.push(:edit) if action[:action].to_sym == :update
      actions.push(action[:action])
    end
    actions
  end
end
