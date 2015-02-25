require 'rails_helper'

RSpec.describe "calendars/edit", :type => :view do
  before(:each) do
    @calendar = assign(:calendar, Calendar.create!(
      :displayname => "MyString",
      :color => "MyString",
      :description => "MyText"
    ))
  end

  it "renders the edit calendar form" do
    render

    assert_select "form[action=?][method=?]", calendar_path(@calendar), "post" do

      assert_select "input#calendar_displayname[name=?]", "calendar[displayname]"

      assert_select "input#calendar_color[name=?]", "calendar[color]"

      assert_select "textarea#calendar_description[name=?]", "calendar[description]"
    end
  end
end
