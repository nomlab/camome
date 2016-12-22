class CalendarProvider < ActiveRecord::Base
  has_many :calendars

  def list(user)
    ## Return Provider list tied to user
    ## If there is no available provider, return nil
  end
end
