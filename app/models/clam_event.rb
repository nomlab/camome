class ClamEvent < ActiveRecord::Base
  belongs_to :clam
  belongs_to :event
end
