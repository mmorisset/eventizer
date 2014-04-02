module AnalysingApi
  module V1
    class MongoEventsController < AnalysingApiController
      def count
        response = @current_event_finder.search()
        render json: { result: response.results.total }
      end
    end
  end
end