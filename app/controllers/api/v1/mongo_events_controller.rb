module Api
  module V1
    class MongoEventsController < ApiController
      def index
        @mongo_events = collection
        respond_with @mongo_events
      end

      def create
        @mongo_event = collection.build.scaffold params.require(:mongo_event)
        @mongo_event.save
        respond_with @mongo_event, status: :created
      end

      def show
        @mongo_event = mongo_event
        respond_with @mongo_event
      end

      def destroy
        @mongo_event = mongo_event
        @mongo_event.destroy
        respond_with @mongo_event
      end

      private
        def mongo_event
          collection.find params.require :id
        end

        def collection
          @current_user.mongo_events
        end
    end
  end
end