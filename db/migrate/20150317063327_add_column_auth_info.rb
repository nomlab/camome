class AddColumnAuthInfo < ActiveRecord::Migration
  def change
    add_column :auth_infos, :parent_id, :integer
    add_column :auth_infos, :parent_type, :string
  end
end
