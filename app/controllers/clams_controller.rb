class ClamsController < ApplicationController
  before_action :set_clam, only: [:show, :edit, :update, :destroy]

  # GET /clams
  # GET /clams.json
  def index
    @clams = Clam.all
  end

  # GET /clams/1
  # GET /clams/1.json
  def show
  end

  # GET /clams/new
  def new
    @clam = Clam.new
  end

  # GET /clams/1/edit
  def edit
  end

  # POST /clams
  # POST /clams.json
  def create
    @clam = Clam.new(clam_params)

    respond_to do |format|
      if @clam.save
        format.html { redirect_to @clam, notice: 'Clam was successfully created.' }
        format.json { render :show, status: :created, location: @clam }
      else
        format.html { render :new }
        format.json { render json: @clam.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /clams/1
  # PATCH/PUT /clams/1.json
  def update
    respond_to do |format|
      if @clam.update(clam_params)
        format.html { redirect_to @clam, notice: 'Clam was successfully updated.' }
        format.json { render :show, status: :ok, location: @clam }
      else
        format.html { render :edit }
        format.json { render json: @clam.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clams/1
  # DELETE /clams/1.json
  def destroy
    @clam.destroy
    respond_to do |format|
      format.html { redirect_to clams_url, notice: 'Clam was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_clam
      @clam = Clam.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def clam_params
      params.require(:clam).permit(:uid, :date, :summary, :options, :content_type, :fixed, :mission_id, :mission_id)
    end
end
