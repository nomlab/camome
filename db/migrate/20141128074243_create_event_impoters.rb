class CreateEventImpoters < ActiveRecord::Migration
  def change
    create_table :event_impoters do |t|

      t.timestamps
    end
  end
end
