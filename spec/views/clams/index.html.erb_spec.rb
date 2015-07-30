require 'rails_helper'

RSpec.describe "clams/index", :type => :view do
  before(:each) do
    assign(:clams, [
      Clam.create!(
        :uid => "Uid",
        :summary => "Summary",
        :options => "MyText",
        :content_type => "Content Type",
        :fixed => false,
        :mission_id => 1,
        :mission => nil
      ),
      Clam.create!(
        :uid => "Uid",
        :summary => "Summary",
        :options => "MyText",
        :content_type => "Content Type",
        :fixed => false,
        :mission_id => 1,
        :mission => nil
      )
    ])
  end

  it "renders a list of clams" do
    render
    assert_select "tr>td", :text => "Uid".to_s, :count => 2
    assert_select "tr>td", :text => "Summary".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Content Type".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
