class Clam < ActiveRecord::Base
  belongs_to :mission
  has_one :resource
  serialize :options
  has_many :clam_events
  has_many :events, through: :clam_events
end
