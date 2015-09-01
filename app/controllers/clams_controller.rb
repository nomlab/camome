# coding: utf-8
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
        format.html {
          flash[:success] = 'メールを送信しました．'
          redirect_to "/missions/inbox"
        }
        format.json { render :show, status: :created, location: @clam }
      else
        format.html { render :new }
        format.json { render json: @clam.errors, status: :unprocessable_entity }
      end
    end

    create_reuse_info(params[:clam][:parent_id], Clam.last.id)
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
    def create_reuse_info(parent_id, child_id)
      reuse_info = ReuseInfo.new(parent_id: parent_id, child_id: child_id)
      reuse_info.save
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_clam
      @clam = Clam.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def clam_params
      params.require(:clam).permit(:uid, :date, :summary, {:options => ['description', 'originator', 'recipients']}, :content_type, :fixed, :mission_id, :mission_id, :description, :originator, :recipients)
    end
end
