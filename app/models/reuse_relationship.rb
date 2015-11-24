class ReuseRelationship < ActiveRecord::Base
  belongs_to :source, class_name: 'Clam'
  belongs_to :destination, class_name: 'Clam'
end
