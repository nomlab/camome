json.array!(@events) do |event|
  json.extract! event, :id, :uid, :categories, :description, :location, :status, :summary, :dtstart, :dtend, :recurrence_id, :related_to, :exdate, :rdate, :created, :last_modified, :sequence, :rrule
  json.url event_url(event, format: :json)
end
