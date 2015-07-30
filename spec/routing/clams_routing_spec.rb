require "rails_helper"

RSpec.describe ClamsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/clams").to route_to("clams#index")
    end

    it "routes to #new" do
      expect(:get => "/clams/new").to route_to("clams#new")
    end

    it "routes to #show" do
      expect(:get => "/clams/1").to route_to("clams#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/clams/1/edit").to route_to("clams#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/clams").to route_to("clams#create")
    end

    it "routes to #update" do
      expect(:put => "/clams/1").to route_to("clams#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/clams/1").to route_to("clams#destroy", :id => "1")
    end

  end
end
