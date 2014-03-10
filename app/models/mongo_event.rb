class MongoEvent
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include History
end
