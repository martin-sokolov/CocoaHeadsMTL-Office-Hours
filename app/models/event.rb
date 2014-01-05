require 'time'
require 'active_support/core_ext/numeric/time'

class Event
  attr_reader :id, :date

  # Creates a new event based on the passed in date
  def initialize(date)
    @id = Time.parse(date).to_f
    @date = date
    save
  end

  # Returns the next event if there is one
  def self.current
    current = all.first
    update current if has_expired? current
    all.first  
  end
  
  # Checks if a given event exists
  def exist?
    REDIS.zscore :event, date
  end

  private
    # Saves a new event for a given date unless it already exists
    def save
      REDIS.zadd :event, id, date  unless exist?
    end

    class << self
      # Returns all events
      def all
        REDIS.zrange :event, 0, -1
      end

      # Checks if a date has already passed
      def has_expired?(date)
        # The event will expires 2 hours after is date
        Time.parse(date).to_f < Time.now.to_f - 2.hours.to_i
      rescue TypeError
        true
      end

      # Removes an event and refreshes the calendar
      def update(date)
        remove date
        Calendar.create_new_events if all.count <= 1
      end

      # Removes an event and deletes all people who were attending it
      def remove(date)
        REDIS.zrem :event, date
        Attending.delete_list_with date
      end
    end
  
end
