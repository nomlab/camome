require 'rails_helper'

RSpec.describe "Clams", :type => :request do
  describe "GET /clams" do
    it "works! (now write some real specs)" do
      get clams_path
      expect(response).to have_http_status(200)
    end
  end
end
