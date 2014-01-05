namespace :twitter do
  desc "Checks if we need to update Twitter with an upcoming meeting notice"
  task :post_upcoming_meeting_if_necessary => :environment do
    unless Event.current.nil?
      future_date = DateTime.parse(Event.current)
      difference_in_hours = ((future_date - DateTime.now) * 24).to_i
      if difference_in_hours.between?(0, 48)
        # Update Twitter with time format Mon, Sep 16 at 09:00
        Twitter.update("Cocoa Office Hours coming up soon: #{future_date.strftime("%a, %b %d at %H:%M")}.  Let others know you're coming: http://bit.ly/cocoaofficehours")
        puts "Notified everyone on Twitter about upcoming meeting"
      end
    end
  end
end