class CreateClams < ActiveRecord::Migration
  def change
    create_table :clams do |t|
      t.string :uid
      t.datetime :date
      t.string :summary
      t.text :options
      t.string :content_type
      t.boolean :fixed, default: false
      t.integer :mission_id
      t.references :mission, index: true

      t.timestamps
    end
  end
end
