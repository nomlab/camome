# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def create_admin_user
  admin_user = User.new(:name => "admin_user")
  admin_user.master_pass = "admin"
  admin_auth_info = MasterAuthInfo.new(:login_name => "admin")
  admin_auth_info = KeyVault.lock(admin_auth_info, admin_user)
  admin_user.auth_info = admin_auth_info
  admin_user.save
  puts "ok: admin user is created."
end

create_admin_user
