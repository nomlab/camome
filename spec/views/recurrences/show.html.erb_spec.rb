require 'rails_helper'

RSpec.describe "recurrences/show", :type => :view do
  before(:each) do
    @recurrence = assign(:recurrence, Recurrence.create!(
      :name => "Name",
      :description => "Description"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Description/)
  end
end
