class EventFinder

  attr_reader :project, :event_collection, :filters, :timeframe, :interval

  def initialize(project, event_collection, filters=nil, timeframe=nil, interval=nil)
    @project = project
    @event_collection = event_collection
    @filters = filters
    @timeframe = timeframe
    @interval = interval
  end

  def count()
    response = MongoEvent.search(search_query).response
    if @interval
      results = response['aggregations']['results']['interval_results']['buckets']
      Jbuilder.encode do |json|
        json.results do
          json.array! results do |result|
            json.value result['doc_count']
            json.time result['key_as_string']
          end
        end
      end
    else
      Jbuilder.encode do |json|
        json.result response['aggregations']['results']['doc_count']
      end
    end
  end

  def search_query()
    @search_query = Jbuilder.encode do |json|
      json.aggs do
        json.results do
          generate_filters json
          if @interval
            generate_interval json
          end
        end
      end
    end
  end

  def generate_filters(json)
    json.filter do
      json.and do
        filter_by_project_and_collection(json)
        if @filters
          @filters.each do |filter|
            add_filter(json, filter)
          end
        end
        if @timeframe
          generate_timeframe json
        end
      end
    end
  end

  def add_filter(json, filter)
    json.child! do
      if ['lt', 'gt', 'lte', 'gte'].include? filter['operator']
        json.range do
          json.set! filter['field'] do
            json.set! filter['operator'], filter['value']
          end
        end
      end
      if filter['operator'] == 'eq'
        json.term do
          json.set! filter['field'], filter['value']
        end
      end
      if filter['operator'] == 'ne'
        json.not do
          json.term do
            json.set! filter['field'], filter['value']
          end
        end
      end
    end
  end

  def filter_by_project_and_collection(json)
    json.child! do
      json.term do
        json.project_id @project.id
      end
    end
    json.child! do
      json.term do
        json.event_collection_id @event_collection.id
      end
    end
  end

  def generate_timeframe(json)
    json.child! do
      json.range do
        json.created_at do
          json.gte Time.parse @timeframe['start_time']
          json.lte Time.parse @timeframe['end_time']
        end
      end
    end
  end

  def generate_interval(json)
    json.aggs do
      json.interval_results do
        json.date_histogram do
          json.field "created_at"
          json.interval @interval
          json.format "yyyy-MM-dd HH-mm-ss Z"
        end
      end
    end
  end
end