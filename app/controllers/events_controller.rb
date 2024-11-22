class EventsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_event, only: %i[edit update destroy]
  
    def index
      @events = Event.all
    end
  
    def new
      @event = Event.new
    end
  
    def create
        @event = current_user.events.build(event_params)
        if @event.save
         SendEventNotificationJob.perform_later(@event)
          @events = Event.all
          respond_to do |format|
            format.turbo_stream
            format.html { redirect_to events_path }
          end
        else
          render :new
        end
      end
  
    def edit
    end
  
    def update
      if @event.update(event_params)
        redirect_to events_path, notice: 'Event updated successfully.'
      else
        render :edit
      end
    end
  
    def destroy
      @event.destroy
      redirect_to events_path, notice: 'Event deleted successfully.'
    end
  
    private
  
    def set_event
      @event = Event.find(params[:id])
    end
  
    def event_params
      params.require(:event).permit(:name, :description, :date, :location)
    end
    
end
