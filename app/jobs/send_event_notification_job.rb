class SendEventNotificationJob < ApplicationJob
  queue_as :default

  def perform(event)
    User.find_each do |user|
      EventMailer.new_event_notification(user, event).deliver_later
    end

    send_google_chat_notification(event)
  end

  private

  def send_google_chat_notification(event)
    uri = URI.parse('https://chat.googleapis.com/v1/spaces/AAAASeradI0/messages?key=AIzaSyDdI0hCZtE6vySjMm-WEfRq3CPzqKqqsHI&token=27eRS3dQ4222HB_4qEubbixS4WMYRZjeY6cU9hmTLI8')
    response = Net::HTTP.post_form(uri, 'text' => "New Event: #{event.name}")
    puts "Google Chat Notification sent: #{response.body}"
  end
end
