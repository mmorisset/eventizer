module CollectionApi
  module V1
    class MongoEventsController < CollectionApiController
      def index
        respond_with current_event_collection.mongo_events
      end

      def create
        @mongo_event = find_or_create_event_collection.mongo_events.build.scaffold params.require(:mongo_event)
        @mongo_event.save 
        respond_with @mongo_event, status: :created
      end

      def show
        @mongo_event = current_mongo_event
        respond_with @mongo_event
      end

      def destroy
        @mongo_event = current_mongo_event
        @mongo_event.destroy
        respond_with @mongo_event
      end

      private
        def current_mongo_event
          current_event_collection.mongo_events.find params.require :id
        end

        def find_or_create_event_collection
          @current_project.event_collections.find_or_create_by(name: params.require(:event_collection))
        end

        def current_event_collection
          @current_project.event_collections.find_by(name: params.require(:event_collection))
        end
    end
  end
end