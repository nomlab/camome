class Recurrence < ActiveRecord::Base
  has_many :events

  def to_recurrence
    return {
      id: id,
      name: name,
      description: description,
      events: self.events.size
    }
  end
end
