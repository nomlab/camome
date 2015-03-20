class CalendarsController < ApplicationController
  before_action :set_calendar, only: [:show, :edit, :update, :destroy]

  # GET /calendars
  # GET /calendars.json
  def index
    @calendars = Calendar.all
  end

  # GET /calendars/1
  # GET /calendars/1.json
  def show
  end

  # GET /calendars/new
  def new
    @calendar = Calendar.new
  end

  # GET /calendars/1/edit
  def edit
  end

  # POST /calendars
  # POST /calendars.json
  def create
    @calendar = Calendar.new(calendar_params)

    respond_to do |format|
      if @calendar.save
        format.html { redirect_to @calendar, notice: 'Calendar was successfully created.' }
        format.json { render :show, status: :created, location: @calendar }
      else
        format.html { render :new }
        format.json { render json: @calendar.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /calendars/1
  # PATCH/PUT /calendars/1.json
  def update
    respond_to do |format|
      if @calendar.update(calendar_params)
        format.html { redirect_to @calendar, notice: 'Calendar was successfully updated.' }
        format.json { render :show, status: :ok, location: @calendar }
      else
        format.html { render :edit }
        format.json { render json: @calendar.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /calendars/1
  # DELETE /calendars/1.json
  def destroy
    @calendar.destroy
    respond_to do |format|
      format.html { redirect_to calendars_url, notice: 'Calendar was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def import
    if params["username"] && params["userpass"]
      @username = params["username"]
      @userpass = params["userpass"]
      my_calendars, commissioned_calendars =
        Calendar.all_calendar_list(@username, @userpass)
      @num_of_my_calendars = my_calendars.length
      @num_of_commissioned_calendars = commissioned_calendars.length
      @calendars = [my_calendars, commissioned_calendars].flatten
      render :action => "import"
    else
      render :action => "auth"
    end
  end

  def create_caldav
    calendars = Calendar.create_from_params(params)
    redirect_to "/events"
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_calendar
    @calendar = Calendar.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def calendar_params
    params.require(:calendar).permit(:displayname, :color, :description)
  end
end
