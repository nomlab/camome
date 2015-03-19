class AddSaltToAuthInfo < ActiveRecord::Migration
  def change
    add_column :auth_infos, :salt, :string
  end
end
