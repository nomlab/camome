require 'rails_helper'

RSpec.describe "recurrences/new", :type => :view do
  before(:each) do
    assign(:recurrence, Recurrence.new(
      :name => "MyString",
      :description => "MyString"
    ))
  end

  it "renders new recurrence form" do
    render

    assert_select "form[action=?][method=?]", recurrences_path, "post" do

      assert_select "input#recurrence_name[name=?]", "recurrence[name]"

      assert_select "input#recurrence_description[name=?]", "recurrence[description]"
    end
  end
end
