require 'rails_helper'

RSpec.describe "calendars/new", :type => :view do
  before(:each) do
    assign(:calendar, Calendar.new(
      :displayname => "MyString",
      :color => "MyString",
      :description => "MyText"
    ))
  end

  it "renders new calendar form" do
    render

    assert_select "form[action=?][method=?]", calendars_path, "post" do

      assert_select "input#calendar_displayname[name=?]", "calendar[displayname]"

      assert_select "input#calendar_color[name=?]", "calendar[color]"

      assert_select "textarea#calendar_description[name=?]", "calendar[description]"
    end
  end
end
