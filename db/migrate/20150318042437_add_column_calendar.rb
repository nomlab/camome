class AddColumnCalendar < ActiveRecord::Migration
  def change
    add_column :calendars, :user_id, :integer
  end
end
