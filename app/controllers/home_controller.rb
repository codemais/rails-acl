class HomeController < ApplicationController
  def index
    @modules = AppModule.all
  end
end
