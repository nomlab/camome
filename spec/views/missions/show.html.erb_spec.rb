require 'rails_helper'

RSpec.describe "missions/show", :type => :view do
  before(:each) do
    @mission = assign(:mission, Mission.create!(
      :name => "Name",
      :description => "Description",
      :deadline => "Deadline",
      :state_id => 1,
      :keyword => "Keyword",
      :parent_id => 2,
      :lft => 3,
      :rgt => 4,
      :depth => 5
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Description/)
    expect(rendered).to match(/Deadline/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Keyword/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/4/)
    expect(rendered).to match(/5/)
  end
end
