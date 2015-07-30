require 'rails_helper'

RSpec.describe "resources/edit", :type => :view do
  before(:each) do
    @resource = assign(:resource, Resource.create!(
      :source => "MyText",
      :type => "",
      :clam => nil
    ))
  end

  it "renders the edit resource form" do
    render

    assert_select "form[action=?][method=?]", resource_path(@resource), "post" do

      assert_select "textarea#resource_source[name=?]", "resource[source]"

      assert_select "input#resource_type[name=?]", "resource[type]"

      assert_select "input#resource_clam_id[name=?]", "resource[clam_id]"
    end
  end
end
