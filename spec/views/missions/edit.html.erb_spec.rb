require 'rails_helper'

RSpec.describe "missions/edit", :type => :view do
  before(:each) do
    @mission = assign(:mission, Mission.create!(
      :name => "MyString",
      :description => "MyString",
      :deadline => "MyString",
      :state_id => 1,
      :keyword => "MyString",
      :parent_id => 1,
      :lft => 1,
      :rgt => 1,
      :depth => 1
    ))
  end

  it "renders the edit mission form" do
    render

    assert_select "form[action=?][method=?]", mission_path(@mission), "post" do

      assert_select "input#mission_name[name=?]", "mission[name]"

      assert_select "input#mission_description[name=?]", "mission[description]"

      assert_select "input#mission_deadline[name=?]", "mission[deadline]"

      assert_select "input#mission_state_id[name=?]", "mission[state_id]"

      assert_select "input#mission_keyword[name=?]", "mission[keyword]"

      assert_select "input#mission_parent_id[name=?]", "mission[parent_id]"

      assert_select "input#mission_lft[name=?]", "mission[lft]"

      assert_select "input#mission_rgt[name=?]", "mission[rgt]"

      assert_select "input#mission_depth[name=?]", "mission[depth]"
    end
  end
end
