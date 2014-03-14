class MongoEvent
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Serializable
  include MongoidAudit::History


  belongs_to :user, inverse_of: :mongo_events

  def scaffold params
    self.data = params[:data]
    self
  end
end
