class AppModule < ApplicationRecord
  has_many :permissions, :dependent => :destroy
  EXCEPT_MODULES = [DeviseController, ApplicationController, HomeController]

  def self.verify_modules
    controllers = Dir.new("#{Rails.root}/app/controllers").entries
    controllers.delete_if{|c| c !~ /_controller/}
    controllers.each do |c|
      controller = controller_name_sanitize(c).constantize
      if EXCEPT_MODULES.exclude?(controller)
        app_module = self.find_or_initialize_by(module: self.name_sanitize(controller.name))
        app_module.update_attributes(controller: controller.name, actions: controller.action_methods)
      end
    end
    self.remove_deleted_modules controllers
  end

  private
    def self.remove_deleted_modules controllers
      controllers = controllers.collect{|c| controller_name_sanitize(c)}
      self.all.each do |m|
        if controllers.exclude?(m.controller)
          m.permissions.delete_all
          m.delete
        end
      end
    end

    def self.controller_name_sanitize controller_name
      controller_name.camelize.gsub(".rb","")
    end

    def self.name_sanitize name
      name.gsub!('Controller', '')
      name.singularize
    end
end
