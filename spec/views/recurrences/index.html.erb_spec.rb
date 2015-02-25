require 'rails_helper'

RSpec.describe "recurrences/index", :type => :view do
  before(:each) do
    assign(:recurrences, [
      Recurrence.create!(
        :name => "Name",
        :description => "Description"
      ),
      Recurrence.create!(
        :name => "Name",
        :description => "Description"
      )
    ])
  end

  it "renders a list of recurrences" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
  end
end
