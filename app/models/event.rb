class Event < ActiveRecord::Base

  def to_event
    return {
      id: id,
      title: summary,
      start: dtstart,
      end: dtend,
      color: "#9FC6E7",
      textColor: "#000000"
    }
  end
end
