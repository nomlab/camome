require 'rails_helper'

RSpec.describe "states/show", :type => :view do
  before(:each) do
    @state = assign(:state, State.create!(
      :name => "Name",
      :color => "Color",
      :position => 1,
      :default => false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Color/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/false/)
  end
end
