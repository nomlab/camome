require 'rails_helper'

RSpec.describe "resources/new", :type => :view do
  before(:each) do
    assign(:resource, Resource.new(
      :source => "MyText",
      :type => "",
      :clam => nil
    ))
  end

  it "renders new resource form" do
    render

    assert_select "form[action=?][method=?]", resources_path, "post" do

      assert_select "textarea#resource_source[name=?]", "resource[source]"

      assert_select "input#resource_type[name=?]", "resource[type]"

      assert_select "input#resource_clam_id[name=?]", "resource[clam_id]"
    end
  end
end
