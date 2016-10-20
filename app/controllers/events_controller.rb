require 'date'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'google/api_client/client_secrets'
require 'google/apis/calendar_v3'
require 'json'
require 'yaml'

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

  def fetch
    #config = YML.load_file('~/.config/camome/config.yml')
    @user_id = "*************"
    @calendar_ids = [@user_id]
    @client_id = ApplicationSettings.oauth.google.application_id
    @client_secret = ApplicationSettings.oauth.google.application_secret
    @oob_url = 'urn:ietf:wg:oauth:2.0:oob'
    
    collection = []
    timeMax = Time.parse(params["end"]).iso8601
    timeMin = Time.parse(params["start"]).iso8601
    @calendar_ids.each do |calendar_id|
      response = get_events(timeMax, timeMin, calendar_id)
      response.items.each do |item|
        collection << {title: item.summary, start: item.start.date, end: item.end.date}
      end
    end
    render json: collection
  end
  
  private
  
  def get_events(timeMax, timeMin, calendar_id)
    params = {:order_by => "startTime", :single_events => "true", :show_deleted => "false", :time_max => timeMax, :time_min => timeMin}
    return google_calendar_api(params, calendar_id)
  end
  
  def authorize
    dir_path = "~/.config/camome"
    client_id = Google::Auth::ClientId.new(@client_id, @client_secret)
    token_store = Google::Auth::Stores::FileTokenStore.new(
      file: File.expand_path("#{dir_path}/google_access_tokens.yml", __FILE__))
    scope = 'https://www.googleapis.com/auth/calendar'
    authorizer = Google::Auth::UserAuthorizer.new(client_id, scope, token_store)
    
    credentials = authorizer.get_credentials(@user_id)
    if credentials.nil?
      url = authorizer.get_authorization_url(
        base_url: @oob_url)
      puts "Open the following URL in the browser and enter the " +
           "resulting code after authorization"
      puts url
      code = STDIN.gets.chomp
      credentials = authorizer.get_and_store_credentials_from_code(
        user_id: @user_id, code: code, base_url: @oob_url)
    end
    return credentials
  end
  
  def google_calendar_api(params, calendar_id)
    service = Google::Apis::CalendarV3::CalendarService.new
    service.client_options.application_name = @application_name
    service.authorization = authorize()
    service.authorization.refresh!
    response = service.list_events(calendar_id, order_by: params[:order_by], show_deleted: params[:show_deleted], single_events: params[:single_events], time_max: params[:time_max], time_min: params[:time_min])
    return response
  end

    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:uid, :categories, :description, :location, :status, :summary, :dtstart, :dtend, :recurrence_id, :related_to, :exdate, :rdate, :created, :last_modified, :sequence, :rrule)
    end
end
