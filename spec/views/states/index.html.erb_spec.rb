require 'rails_helper'

RSpec.describe "states/index", :type => :view do
  before(:each) do
    assign(:states, [
      State.create!(
        :name => "Name",
        :color => "Color",
        :position => 1,
        :default => false
      ),
      State.create!(
        :name => "Name",
        :color => "Color",
        :position => 1,
        :default => false
      )
    ])
  end

  it "renders a list of states" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Color".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
