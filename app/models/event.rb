# -*- coding: utf-8 -*-
class Event < ActiveRecord::Base

  belongs_to :calendar
  belongs_to :recurrence
  validates_presence_of :summary, :dtstart, :dtend
  has_many :clam_events
  has_many :clams, through: :clam_events


  def duration
    duration = self.dtend - self.dtstart
    return duration
  end

  def to_event
    return {
      id: id,
      recurrence_id: self.recurrence_id,
      title: summary,
      start: dtstart,
      end: dtend,
      arrange_date: ApplicationController.helpers.arrange_date(self.dtstart, self.dtend),
      color: "#9FC6E7",
      textColor: "#000000"
    }
  end
end
