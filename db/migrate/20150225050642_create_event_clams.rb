class CreateEventClams < ActiveRecord::Migration
  def change
    create_table :event_clams do |t|

      t.timestamps
    end
  end
end
