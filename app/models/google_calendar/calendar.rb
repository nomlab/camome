module GoogleCalendar
  class Calendar
    def initialize(data_store)
      @data_store = data_store
      @calendars = {}
      calendars = @data_store.load("calendars")
      calendars["calendars"]["items"].each do |calendar|
        @calendars["#{calendar["id"]}"] = calendar
      end
    end

    def scan(date_start, date_end)
      month_list = (date_start .. date_end).map(&:beginning_of_month).uniq
      collection = []
      month_list.each do |date|
        month = "#{date.year}-#{date.month}"
        events = @data_store.load("*-#{month}")
        if events != nil then
          events.each do |k, v|
            calendar_id = k.split("-")[0]
            color = @calendars["#{calendar_id}"]["background_color"]
            v["items"].each do |event|
              collection << GoogleCalendar::Event.new(event,color).to_fullcalendar
            end
          end
        end
      end
      collection
    end# method scan
  end# class Calnedar
end# module GoogleCalendar
