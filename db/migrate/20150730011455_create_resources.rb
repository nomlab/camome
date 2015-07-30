class CreateResources < ActiveRecord::Migration
  def change
    create_table :resources do |t|
      t.text :source
      t.string :type
      t.references :clam, index: true

      t.timestamps
    end
    add_index :resources, :type
  end
end
