module GoogleCalendar
  class Calendar
    def initialize(data_store)
      @data_store = data_store
    end

    def scan(date_start, date_end)
      month_list = (date_start .. date_end).map(&:beginning_of_month).uniq
      collection = []
      month_list.each do |date|
        month = "#{date.year}-#{date.month}"
        events = @data_store.load(month)
        if events != nil then
          events["items"].each do |event|
            collection << GoogleCalendar::Event.new(event).to_fullcalendar
          end
        end
      end
      return collection
    end# method scan
  end# class Calnedar
end# module GoogleCalendar
