class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.text :uid
      t.text :categories
      t.text :description
      t.text :location
      t.text :status
      t.text :summary
      t.datetime :dtstart
      t.datetime :dtend
      t.integer :recurrence_id
      t.text :related_to
      t.datetime :exdate
      t.datetime :rdate
      t.datetime :created
      t.datetime :last_modified
      t.datetime :sequence
      t.string :rrule

      t.timestamps
    end
  end
end
