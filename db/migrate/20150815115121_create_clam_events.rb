class CreateClamEvents < ActiveRecord::Migration
  def change
    create_table :clam_events do |t|
      t.integer :clam_id
      t.integer :event_id

      t.timestamps
    end
  end
end
