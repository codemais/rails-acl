class AppModule < ApplicationRecord
  def self.verify
    ApplicationController.subclasses.each do |controller|
      app_module = self.new
      app_module.name = self.name_sanitize(controller.name)
      app_module.controller = controller.name
      app_module.actions = controller.action_methods
      app_module.save unless self.find_by(name: app_module.name).present?
    end
  end

  private
    def self.name_sanitize name
      name.gsub!('Controller', '')
      name.singularize
    end
end
