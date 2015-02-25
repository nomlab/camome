json.array!(@recurrences) do |recurrence|
  json.extract! recurrence, :id, :name, :description
  json.url recurrence_url(recurrence, format: :json)
end
