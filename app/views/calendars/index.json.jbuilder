json.array!(@calendars) do |calendar|
  json.extract! calendar, :id, :displayname, :color, :description
  json.url calendar_url(calendar, format: :json)
end
