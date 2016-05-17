class RenameReuseInfoToReuseRelationship < ActiveRecord::Migration
  def change
    rename_table :reuse_infos, :reuse_relationships
  end
end
