require 'rails_helper'

RSpec.describe "missions/index", :type => :view do
  before(:each) do
    assign(:missions, [
      Mission.create!(
        :name => "Name",
        :description => "Description",
        :deadline => "Deadline",
        :state_id => 1,
        :keyword => "Keyword",
        :parent_id => 2,
        :lft => 3,
        :rgt => 4,
        :depth => 5
      ),
      Mission.create!(
        :name => "Name",
        :description => "Description",
        :deadline => "Deadline",
        :state_id => 1,
        :keyword => "Keyword",
        :parent_id => 2,
        :lft => 3,
        :rgt => 4,
        :depth => 5
      )
    ])
  end

  it "renders a list of missions" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => "Deadline".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Keyword".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
  end
end
