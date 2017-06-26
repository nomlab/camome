class GoogleCalendarEvent
  def initialize(event)
    @event = event
  end

  def to_fullcalendar
    full_event = {}
    full_event["id"] = @event["id"]
    full_event["title"] = @event["summary"]
    full_event["start"] = @event["start"]["dateTime"] || @event["start"]["date"]
    full_event["end"] = @event["end"]["dateTime"] || @event["end"]["date"]
    if  @event["start"]["date"] then
      full_event["allDay"] = true
    else
      full_event["allDay"] = false
    end
    return full_event
  end
end
