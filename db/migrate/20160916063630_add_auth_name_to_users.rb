class AddAuthNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :auth_name, :string
  end
end
