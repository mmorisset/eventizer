class Project
  include Mongoid::Document
  field :name, type: String

  belongs_to :user, inverse_of: :projects
  has_many :event_collections, inverse_of: :project, dependent: :destroy

  validates_presence_of :name, :user
end
