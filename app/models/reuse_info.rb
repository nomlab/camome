class ReuseInfo < ActiveRecord::Base
  belongs_to :parent, class_name: 'Clam'
  belongs_to :child, class_name: 'Clam'
end
