class RenameColumnToReuseRelationship < ActiveRecord::Migration
  def change
    rename_column :reuse_relationships, :parent_id, :source_id
    rename_column :reuse_relationships, :child_id, :destination_id
  end
end
