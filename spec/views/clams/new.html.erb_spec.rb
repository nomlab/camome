require 'rails_helper'

RSpec.describe "clams/new", :type => :view do
  before(:each) do
    assign(:clam, Clam.new(
      :uid => "MyString",
      :summary => "MyString",
      :options => "MyText",
      :content_type => "MyString",
      :fixed => false,
      :mission_id => 1,
      :mission => nil
    ))
  end

  it "renders new clam form" do
    render

    assert_select "form[action=?][method=?]", clams_path, "post" do

      assert_select "input#clam_uid[name=?]", "clam[uid]"

      assert_select "input#clam_summary[name=?]", "clam[summary]"

      assert_select "textarea#clam_options[name=?]", "clam[options]"

      assert_select "input#clam_content_type[name=?]", "clam[content_type]"

      assert_select "input#clam_fixed[name=?]", "clam[fixed]"

      assert_select "input#clam_mission_id[name=?]", "clam[mission_id]"

      assert_select "input#clam_mission_id[name=?]", "clam[mission_id]"
    end
  end
end
