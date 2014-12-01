require 'rails_helper'

RSpec.describe "events/index", :type => :view do
  before(:each) do
    assign(:events, [
      Event.create!(
        :uid => "MyText",
        :categories => "MyText",
        :description => "MyText",
        :location => "MyText",
        :status => "MyText",
        :summary => "MyText",
        :recurrence_id => 1,
        :related_to => "MyText",
        :rrule => "Rrule"
      ),
      Event.create!(
        :uid => "MyText",
        :categories => "MyText",
        :description => "MyText",
        :location => "MyText",
        :status => "MyText",
        :summary => "MyText",
        :recurrence_id => 1,
        :related_to => "MyText",
        :rrule => "Rrule"
      )
    ])
  end

  it "renders a list of events" do
    render
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Rrule".to_s, :count => 2
  end
end
