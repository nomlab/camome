require 'rails_helper'

RSpec.describe "events/new", :type => :view do
  before(:each) do
    assign(:event, Event.new(
      :uid => "MyText",
      :categories => "MyText",
      :description => "MyText",
      :location => "MyText",
      :status => "MyText",
      :summary => "MyText",
      :recurrence_id => 1,
      :related_to => "MyText",
      :rrule => "MyString"
    ))
  end

  it "renders new event form" do
    render

    assert_select "form[action=?][method=?]", events_path, "post" do

      assert_select "textarea#event_uid[name=?]", "event[uid]"

      assert_select "textarea#event_categories[name=?]", "event[categories]"

      assert_select "textarea#event_description[name=?]", "event[description]"

      assert_select "textarea#event_location[name=?]", "event[location]"

      assert_select "textarea#event_status[name=?]", "event[status]"

      assert_select "textarea#event_summary[name=?]", "event[summary]"

      assert_select "input#event_recurrence_id[name=?]", "event[recurrence_id]"

      assert_select "textarea#event_related_to[name=?]", "event[related_to]"

      assert_select "input#event_rrule[name=?]", "event[rrule]"
    end
  end
end
