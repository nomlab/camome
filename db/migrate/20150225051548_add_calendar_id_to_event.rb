class AddCalendarIdToEvent < ActiveRecord::Migration

  def up
    add_column :events, :calendar_id, :integer
    add_relation_between_events_and_calendar
  end

  def down
    remove_column :events, :calendar_id
  end

  private
  def add_relation_between_events_and_calendar
    Event.all.each do |e|
      e.calendar_id = 1
      e.save
    end if Calendar.find(1)
  end
end
