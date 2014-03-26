class MongoEvent
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Serializable
  include MongoidAudit::History
  include ElasticSearch::Searchable
  include Eventizer::MongoEventIndex
  include Elasticsearch::Model::Callbacks

  index_name "mongo_events-#{Rails.env}"

  belongs_to :event_collection, inverse_of: :mongo_events

  validates_presence_of :event_collection

  def scaffold(params)
    self.data = params[:data]
    self
  end
end
