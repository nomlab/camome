class AddDetailsToAuthInfos < ActiveRecord::Migration
  def change
    add_column :auth_infos, :token, :string
    add_column :auth_infos, :refresh_token, :string
  end
end
