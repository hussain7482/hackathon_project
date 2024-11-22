class EventMailer < ApplicationMailer
    def new_event_notification(user, event)
      @user = user
      @event = event
      mail(to: @user.email, subject: "New Event: #{@event.name}")
    end
  end
