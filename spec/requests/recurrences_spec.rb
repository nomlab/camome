require 'rails_helper'

RSpec.describe "Recurrences", :type => :request do
  describe "GET /recurrences" do
    it "works! (now write some real specs)" do
      get recurrences_path
      expect(response).to have_http_status(200)
    end
  end
end
