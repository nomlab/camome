require 'rails_helper'

RSpec.describe "recurrences/edit", :type => :view do
  before(:each) do
    @recurrence = assign(:recurrence, Recurrence.create!(
      :name => "MyString",
      :description => "MyString"
    ))
  end

  it "renders the edit recurrence form" do
    render

    assert_select "form[action=?][method=?]", recurrence_path(@recurrence), "post" do

      assert_select "input#recurrence_name[name=?]", "recurrence[name]"

      assert_select "input#recurrence_description[name=?]", "recurrence[description]"
    end
  end
end
