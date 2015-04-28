class InboxController < ApplicationController
  # GET /inbox
  def missions
    @events = Event.all
  end
end
