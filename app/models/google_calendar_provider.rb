class GoogleCalendarProvider < CalendarProvider
  has_one :google_calendar_auth_info, as: :parent, dependent: :destroy
end
