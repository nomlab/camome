class CreateMissions < ActiveRecord::Migration
  def change
    create_table :missions do |t|
      t.string :name
      t.string :description
      t.string :deadline
      t.integer :state_id
      t.string :keyword
      t.integer :parent_id, null: true
      t.integer :lft, null: false
      t.integer :rgt, null: false
      t.integer :depth, null: false, default: 0

      t.timestamps
    end
    add_index :missions, :parent_id
    add_index :missions, :lft
    add_index :missions, :rgt
    add_index :missions, :depth
  end
end
