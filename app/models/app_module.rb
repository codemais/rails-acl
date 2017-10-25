class AppModule < ApplicationRecord
  has_many :permissions, dependent: :destroy
  EXCEPT_MODULES = [
    DeviseController, ApplicationController, HomeController
  ].freeze

  def self.verify_modules
    controllers = Dir.new("#{Rails.root}/app/controllers").entries
    controllers.delete_if { |c| c !~ /_controller/ }
    controllers.each do |c|
      c = controller_name_sanitize(c).constantize
      next unless EXCEPT_MODULES.exclude?(c)
      update_app_module(c)
    end
    remove_deleted_modules controllers
  end

  def self.update_app_module(c)
    app_module = find_or_initialize_by(module: name_sanitize(c.name))
    app_module.update_attributes(
      controller: c.name,
      actions: c.action_methods.select { |a| %i[new edit].exclude?(a.to_sym) }
    )
  end

  def self.remove_deleted_modules(controllers)
    controllers = controllers.collect { |c| controller_name_sanitize(c) }
    all.each do |m|
      if controllers.exclude?(m.controller)
        m.permissions.delete_all
        m.delete
      end
    end
  end

  def self.controller_name_sanitize(controller_name)
    controller_name.camelize.gsub('.rb', '')
  end

  def self.name_sanitize(name)
    name.gsub!('Controller', '')
    name.singularize
  end
end
