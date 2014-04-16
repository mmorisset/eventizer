module AnalysingApi
  module V1
    class MongoEventsController < AnalysingApiController
      def count
        render json: @current_event_finder.count()
      end
    end
  end
end