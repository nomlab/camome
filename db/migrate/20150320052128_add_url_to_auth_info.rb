class AddUrlToAuthInfo < ActiveRecord::Migration
  def change
    add_column :auth_infos, :url, :string
  end
end
