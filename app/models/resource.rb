class Resource < ActiveRecord::Base
  belongs_to :clam
end

class Resource::Mail < Resource
end

class Resource::Evernote < Resource
end

class Resource::Slack < Resource
end

class Resource::Toggl < Resource
end
