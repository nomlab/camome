require 'rails_helper'

RSpec.describe "clams/show", :type => :view do
  before(:each) do
    @clam = assign(:clam, Clam.create!(
      :uid => "Uid",
      :summary => "Summary",
      :options => "MyText",
      :content_type => "Content Type",
      :fixed => false,
      :mission_id => 1,
      :mission => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Uid/)
    expect(rendered).to match(/Summary/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Content Type/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(//)
  end
end
