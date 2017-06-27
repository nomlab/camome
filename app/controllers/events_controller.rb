require 'date'

class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  # GET /events
  # GET /events.json
  def index
    unless params[:recurrence_id].nil?
      recurrence_id = params[:recurrence_id]== "nil" ? nil : params[:recurrence_id]
      @events = Event.where(recurrence_id: recurrence_id).order("dtstart DESC")
    else
      @events = Event.all.order("dtstart DESC")
    end

    @point_date = DateTime.now.prev_year.beginning_of_month
    @point_event = Event.where("dtstart  >= ?", @point_date).order("dtstart ASC").first
    @recurrences = Recurrence.all
    @event = Event.new

    respond_to do |format|
      format.html
      format.json {render json: @events.map(&:to_event)}
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @clams = @event.clams
  end

  # GET /events/new
  def new
    @event = Event.new
    @event.summary = params[:event][:summary]
    @event.dtstart = params[:event][:dtstart]
    @event.dtend = params[:event][:dtend]
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)
    @event.recurrence_id = Recurrence.inbox.id
    if params[:clam_id] != nil
      @clam = Clam.find(params[:clam_id])
      @clam.events << @event
    end

    json = event_to_json(@event)
    puts "----------------------"
    puts json
    puts "----------------------"

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
    if params[:clam_id].present?
      @clam = Clam.find(params[:clam_id])
      @clam.events << @event
    end

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

  def ajax_create_event_from_old_event
    event = params[:event]== "nil" ? nil : params[:event] unless params[:event].nil?
    summary = event["summary"]
    dtstart = event["dtstart"]
    dtend = event["dtend"]
    origin_event_id = event["origin_event_id"]

    origin_event = Event.find_by(id: origin_event_id)

    event = Event.new(summary: summary,
                      dtstart: dtstart,
                      dtend: dtend)
    event.recurrence_id = origin_event.recurrence_id
    event.save

    respond_to do |format|
      format.html {
        flash[:success] = 'Event was successfully created.'
        redirect_to event
      }
      format.json { render json: recurrence }
    end
  end

  def list
    cal = CalendarCollection.new(DataStore.create(:redis))
    date_start = Date.parse(params["start"])
    date_end = Date.parse(params["end"])
    events = cal.scan(date_start, date_end)
    render json: events
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = Event.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def event_params
    params.require(:event).permit(:uid, :categories, :description, :location, :status, :summary, :dtstart, :dtend, :recurrence_id, :related_to, :exdate, :rdate, :created, :last_modified, :sequence, :rrule, :all_day)
  end

  def event_to_json(event)
    e = {}
    if event.all_day
      e["end"] = {"date" => event.dtend, "timeZone" => "Asia/Tokyo"}
      e["start"] = {"date" => event.dtstart, "timeZone" => "Asia/Tokyo"}
    else
      e["end"] = {"dateTime" => event.dtend, "timeZone" => "Asia/Tokyo"}
      e["start"] = {"dateTime" => event.dtstart, "timeZone" => "Asia/Tokyo"}
    end
    e["summary"] = event.summary
    e["location"] = event.location
    e["description"] = event.description
    return e.to_json
  end# end event_to_json
end# end EventsController
