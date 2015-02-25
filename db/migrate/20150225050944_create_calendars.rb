class CreateCalendars < ActiveRecord::Migration

  def up
    create_table :calendars do |t|
      t.string :displayname
      t.string :color
      t.text :description

      t.timestamps
    end
    create_default_calendar
  end

  def down
    drop_table :calendars
  end

  private
  def create_default_calendar
    cal = Calendar.new(:displayname => "default calendar",
                       :color => "#dc143c",
                       :description => "")
    cal.save
  end
end
