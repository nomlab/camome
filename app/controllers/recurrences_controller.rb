class RecurrencesController < ApplicationController
  before_action :set_recurrence, only: [:show, :edit, :update, :destroy]

  # GET /recurrences
  # GET /recurrences.json
  def index
    @recurrences = Recurrence.all
  end

  # GET /recurrences/1
  # GET /recurrences/1.json
  def show
  end

  # GET /recurrences/new
  def new
    @recurrence = Recurrence.new
  end

  # GET /recurrences/1/edit
  def edit
  end

  # POST /recurrences
  # POST /recurrences.json
  def create
    @recurrence = Recurrence.new(recurrence_params)

    respond_to do |format|
      if @recurrence.save
        format.html { redirect_to @recurrence, notice: 'Recurrence was successfully created.' }
        format.json { render :show, status: :created, location: @recurrence }
      else
        format.html { render :new }
        format.json { render json: @recurrence.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /recurrences/1
  # PATCH/PUT /recurrences/1.json
  def update
    respond_to do |format|
      if @recurrence.update(recurrence_params)
        format.html { redirect_to @recurrence, notice: 'Recurrence was successfully updated.' }
        format.json { render :show, status: :ok, location: @recurrence }
      else
        format.html { render :edit }
        format.json { render json: @recurrence.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recurrences/1
  # DELETE /recurrences/1.json
  def destroy
    @recurrence.destroy
    respond_to do |format|
      format.html { redirect_to recurrences_url, notice: 'Recurrence was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def get_last
  recurrence = Recurrence.last
  {recurrence_name: recurrence.name}.to_json
end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_recurrence
      @recurrence = Recurrence.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def recurrence_params
      params.require(:recurrence).permit(:name, :description)
    end
end
