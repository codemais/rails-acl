class AppModulesController < ApplicationController
  before_action :set_app_module, only: [:show, :edit, :update, :destroy]
  before_action :verify_modules, only: [:index]

  # GET /app_modules
  # GET /app_modules.json
  def index
    @app_modules = AppModule.all
  end

  # GET /app_modules/1
  # GET /app_modules/1.json
  def show
  end

  # GET /app_modules/new
  def new
    @app_module = AppModule.new
  end

  # GET /app_modules/1/edit
  def edit
  end

  # POST /app_modules
  # POST /app_modules.json
  def create
    @app_module = AppModule.new(app_module_params)

    respond_to do |format|
      if @app_module.save
        format.html { redirect_to @app_module, notice: 'App module was successfully created.' }
        format.json { render :show, status: :created, location: @app_module }
      else
        format.html { render :new }
        format.json { render json: @app_module.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /app_modules/1
  # PATCH/PUT /app_modules/1.json
  def update
    respond_to do |format|
      if @app_module.update(app_module_params)
        format.html { redirect_to @app_module, notice: 'App module was successfully updated.' }
        format.json { render :show, status: :ok, location: @app_module }
      else
        format.html { render :edit }
        format.json { render json: @app_module.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /app_modules/1
  # DELETE /app_modules/1.json
  def destroy
    @app_module.destroy
    respond_to do |format|
      format.html { redirect_to app_modules_url, notice: 'App module was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_app_module
      @app_module = AppModule.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def app_module_params
      params.require(:app_module).permit(:name, :controller, :actions)
    end

    def verify_modules
      AppModule.verify
    end
end
