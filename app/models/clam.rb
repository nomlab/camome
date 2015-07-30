class Clam < ActiveRecord::Base
  belongs_to :mission
  has_one :resource
  serialize :options
end
