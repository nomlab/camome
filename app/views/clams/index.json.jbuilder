json.array!(@clams) do |clam|
  json.extract! clam, :id, :uid, :date, :summary, :options, :content_type, :fixed, :mission_id, :mission_id
  json.url clam_url(clam, format: :json)
end
