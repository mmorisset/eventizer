class EventCollection
  include Mongoid::Document

  field :name, type: String

  validates_uniqueness_of :name, scope: :project_id
  validates_presence_of :name, :project

  belongs_to :project, inverse_of: :event_collections
  has_many :mongo_events, inverse_of: :event_collection, dependent: :destroy
end
