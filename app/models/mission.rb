class Mission < ActiveRecord::Base
  acts_as_nested_set
  after_save :rebuild_nested_set
  has_many :clams
  belongs_to :state
end
