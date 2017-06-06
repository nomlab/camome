class GoogleCalendarEvent < Event
  def self.to_fullcalendar(e)
    event = {}
    event["id"] = e["id"]
    event["title"] = e["summary"]
    event["start"] = e["start"]["dateTime"] || e["start"]["date"]
    event["end"] = e["end"]["dateTime"] || e["end"]["date"]
    if  e["start"]["date"] then
      event["allDay"] = true
    else
      event["allDay"] = false
    end
    return event
  end
end
