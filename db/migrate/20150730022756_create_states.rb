class CreateStates < ActiveRecord::Migration
  def change
    create_table :states do |t|
      t.string :name
      t.string :color
      t.integer :position
      t.boolean :default

      t.timestamps
    end
  end
end
