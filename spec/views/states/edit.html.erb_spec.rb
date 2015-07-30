require 'rails_helper'

RSpec.describe "states/edit", :type => :view do
  before(:each) do
    @state = assign(:state, State.create!(
      :name => "MyString",
      :color => "MyString",
      :position => 1,
      :default => false
    ))
  end

  it "renders the edit state form" do
    render

    assert_select "form[action=?][method=?]", state_path(@state), "post" do

      assert_select "input#state_name[name=?]", "state[name]"

      assert_select "input#state_color[name=?]", "state[color]"

      assert_select "input#state_position[name=?]", "state[position]"

      assert_select "input#state_default[name=?]", "state[default]"
    end
  end
end
