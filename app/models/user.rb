class User < ActiveRecord::Base
  has_many :calendars, dependent: :destroy
  has_one :auth_info, as: :parent,
  class_name: "MasterAuthInfo", dependent: :destroy
end
