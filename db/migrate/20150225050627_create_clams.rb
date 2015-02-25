class CreateClams < ActiveRecord::Migration
  def change
    create_table :clams do |t|
      t.string :title
      t.string :description
      t.string :type
      t.date :date
      t.string :link

      t.timestamps
    end
  end
end
