class AddTypeToCalendarProvider < ActiveRecord::Migration
  def change
    add_column :calendar_providers, :type, :string
  end
end
