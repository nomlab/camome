require 'rails_helper'

RSpec.describe "Missions", :type => :request do
  describe "GET /missions" do
    it "works! (now write some real specs)" do
      pending("Not implemnted.")
      fail
    end
  end

  describe "POST /missions/inbox/missions", autodoc: true do
    it "creates a unorganized mission." do
      pending("Not implemnted.")
      fail
    end
  end

  describe "POST /missions", autodoc: true do
    it "creates a root mission." do
      pending("Not implemnted.")
      fail
    end
  end

  describe "POST /missions/:parent_id/missions", autodoc: true do
    it "creates a child mission." do
      pending("Not implemnted.")
      fail
    end
  end
end
