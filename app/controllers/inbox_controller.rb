class InboxController < ApplicationController
  # GET /inbox
  def missions
    @events = Event.all
  end

  def recurrences
    @events = Event.all
    @recurrences = Recurrence.all
  end
end
