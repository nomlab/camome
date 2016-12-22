class AddUserIdToCalendarProvider < ActiveRecord::Migration
  def change
    add_column :calendar_providers, :user_id, :integer
  end
end
