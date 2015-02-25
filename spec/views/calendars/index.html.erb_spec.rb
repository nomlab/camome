require 'rails_helper'

RSpec.describe "calendars/index", :type => :view do
  before(:each) do
    assign(:calendars, [
      Calendar.create!(
        :displayname => "Displayname",
        :color => "Color",
        :description => "MyText"
      ),
      Calendar.create!(
        :displayname => "Displayname",
        :color => "Color",
        :description => "MyText"
      )
    ])
  end

  it "renders a list of calendars" do
    render
    assert_select "tr>td", :text => "Displayname".to_s, :count => 2
    assert_select "tr>td", :text => "Color".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
