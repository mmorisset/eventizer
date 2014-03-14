class Authorization
  include Mongoid::Document
  include MongoidAudit::History

  before_create :generate_secret

  field :name,   type: String
  field :access, type: String
  field :secret, type: String

  validates_uniqueness_of :secret
  validates_presence_of :name, :access, :user

  belongs_to :user, inverse_of: :authorizations
  
  private
  
    def generate_secret
      self.secret = SecureRandom.hex unless self.secret.present?
    end
end
