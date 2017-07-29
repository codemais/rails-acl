class Profile < ApplicationRecord
  has_many :permissions, :dependent => :destroy

  def update params
    save_permissions params
    super params.except(:permissions)
  end

  def has_action(app_module_id, action)
    permissions = self.permissions.where(app_module_id: app_module_id)
    return permissions.empty? ? false : permissions.first.actions.include?(action)
  end

  def save_permissions params
    self.permissions.delete_all
    permissions = params[:permissions].present? ? params[:permissions] : []
    permissions.each do |i|
      app_module_id = permissions[i][:app_module]
      actions = permissions[i][:actions].to_h.collect {|k,v| v[:action]}
      self.permissions << Permission.new(app_module_id: app_module_id, actions: actions)
    end
  end

end
