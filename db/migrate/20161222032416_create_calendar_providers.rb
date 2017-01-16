class CreateCalendarProviders < ActiveRecord::Migration
  def change
    create_table :calendar_providers do |t|

      t.timestamps
    end
  end
end
