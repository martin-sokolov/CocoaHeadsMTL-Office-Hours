require 'net/http'
require 'json'

class Calendar

  class << self
    # Creates new events based on the parsed Google Calendar data
    def create_new_events
      get_next_calendar_events.map { |calendar_event| Event.new calendar_event["start"]["dateTime"] }
    rescue NoMethodError
      []
    end
    
    private
      # Parses the calendar events
      def get_next_calendar_events
        next_events = JSON.parse search_for_future_calendar_events
        next_events["items"]
      end
      
      # Requests the next meeting events from the shared Google Calendar
      def search_for_future_calendar_events
        uri = URI.parse("https://www.googleapis.com/calendar/v3/calendars/ufbobbo%40gmail.com/events?orderBy=startTime&singleEvents=true&timeMin=#{Time.now.strftime("%FT%T%:z")}&fields=items(id%2Cstart)&key=#{ENV['GOOGLE_API_KEY']}")
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        request = Net::HTTP::Get.new(uri.request_uri)
        response = http.request(request).body
      end
  end
  
end
