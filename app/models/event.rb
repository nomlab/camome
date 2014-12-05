# -*- coding: utf-8 -*-
class Event < ActiveRecord::Base

  validates_presence_of :summary, :dtstart, :dtend

  def to_event
    return {
      id: id,
      title: summary,
      start: dtstart,
      end: dtend,
      color: "#9FC6E7",
      textColor: "#000000"
    }
  end
end
