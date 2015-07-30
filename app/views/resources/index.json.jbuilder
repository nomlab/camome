json.array!(@resources) do |resource|
  json.extract! resource, :id, :source, :type, :clam_id
  json.url resource_url(resource, format: :json)
end
