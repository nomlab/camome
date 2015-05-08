require 'date'

class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  # GET /events
  # GET /events.json
  def index
    unless params[:recurrence_id].nil?
      recurrence_id = params[:recurrence_id]== "nil" ? nil : params[:recurrence_id]
      @events = Event.where(recurrence_id: recurrence_id).order("dtstart ASC")
    else
      @events = Event.all.order("dtstart ASC")
    end

    @point_date = DateTime.now.prev_year.beginning_of_month
    @point_event = Event.where("dtstart  >= ?", @point_date).order("dtstart ASC").first
    @recurrences = Recurrence.all

    respond_to do |format|
      format.html
      format.json {render json: @events.map(&:to_event)}
    end

  end

  # GET /events/1
  # GET /events/1.json
  def show
    respond_to do |format|
      format.html
      format.json {render json: Event.all.map(&:to_event)}
    end
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  ############# Recurrence ############
  def create_recurrence
    recurrence = Recurrence.create({
                        name: params[:name],
                      })

    if recurrence.save
      html = render_to_string :partial => "recurrence", :collection => [recurrence]
      render :json => {:success => 1, :html => html}
    else
      render :json => {:error => recurrence.errors}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:uid, :categories, :description, :location, :status, :summary, :dtstart, :dtend, :recurrence_id, :related_to, :exdate, :rdate, :created, :last_modified, :sequence, :rrule)
    end
end
