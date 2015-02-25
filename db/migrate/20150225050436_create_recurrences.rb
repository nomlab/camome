class CreateRecurrences < ActiveRecord::Migration
  def change
    create_table :recurrences do |t|
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
