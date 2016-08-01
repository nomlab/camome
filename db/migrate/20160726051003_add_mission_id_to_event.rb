class AddMissionIdToEvent < ActiveRecord::Migration
  def change
    add_column :events, :mission_id, :integer
  end
end
