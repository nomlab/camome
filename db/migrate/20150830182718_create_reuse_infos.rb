class CreateReuseInfos < ActiveRecord::Migration
  def change
    create_table :reuse_infos do |t|
      t.integer :parent_id
      t.integer :child_id

      t.timestamps
    end
  end
end
