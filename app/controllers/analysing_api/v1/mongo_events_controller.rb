module AnalysingApi
  module V1
    class MongoEventsController < AnalysingApiController
      def count
        response = MongoEvent.search(
        {size: 0, aggs: {result: {value_count: {field: "id"}}}})
        p response.results.aggregations
        render json: { result: response.count }
      end

      private
        def find_or_create_event_collection
          @current_project.event_collections.find_or_create_by(name: params.require(:event_collection))
        end

        def current_event_collection
          @current_project.event_collections.find_by(name: params.require(:event_collection))
        end
    end
  end
end