class Calendar < ActiveRecord::Base
  has_many :events, dependent: :destroy
  belongs_to :user
  has_one :auth_info, as: :parent,
  class_name: "CalendarAuthInfo", dependent: :destroy
end
