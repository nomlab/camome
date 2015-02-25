require "rails_helper"

RSpec.describe RecurrencesController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/recurrences").to route_to("recurrences#index")
    end

    it "routes to #new" do
      expect(:get => "/recurrences/new").to route_to("recurrences#new")
    end

    it "routes to #show" do
      expect(:get => "/recurrences/1").to route_to("recurrences#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/recurrences/1/edit").to route_to("recurrences#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/recurrences").to route_to("recurrences#create")
    end

    it "routes to #update" do
      expect(:put => "/recurrences/1").to route_to("recurrences#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/recurrences/1").to route_to("recurrences#destroy", :id => "1")
    end

  end
end
