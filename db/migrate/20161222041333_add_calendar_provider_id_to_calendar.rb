class AddCalendarProviderIdToCalendar < ActiveRecord::Migration
  def change
    add_column :calendars, :calendar_provider_id, :integer
  end
end
