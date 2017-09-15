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
        @data_store.glob("*-#{month}").each do |key|
          begin
            events = JSON.parse(@data_store.load(key))
            events["items"].each do |event|
              collection << GoogleCalendar::Event.new(event).to_fullcalendar
            end
          rescue
            Rails.logger.warn("There are invalid format events.")
          end
        end
      end
      collection
    end# method scan
  end# class Calnedar
end# module GoogleCalendar
