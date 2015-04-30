class InboxController < ApplicationController
  # GET /inbox
  def missions
    @events = Event.all
  end

  def recurrences
    @events = Event.where("recurrence_id IS ?",nil).order("dtstart ASC")
    @recurrences = Recurrence.all
  end
end
