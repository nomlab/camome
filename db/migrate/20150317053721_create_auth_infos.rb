class CreateAuthInfos < ActiveRecord::Migration
  def change
    create_table :auth_infos do |t|
      t.string :login_name
      t.string :encrypted_pass
      t.string :type

      t.timestamps
    end
  end
end
