require 'rails_helper'

RSpec.describe "events/show", :type => :view do
  before(:each) do
    @event = assign(:event, Event.create!(
      :uid => "MyText",
      :categories => "MyText",
      :description => "MyText",
      :location => "MyText",
      :status => "MyText",
      :summary => "MyText",
      :recurrence_id => 1,
      :related_to => "MyText",
      :rrule => "Rrule"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Rrule/)
  end
end
