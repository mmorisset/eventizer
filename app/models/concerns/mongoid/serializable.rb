module Mongoid::Serializable
  extend ActiveSupport::Concern

  included do
    field :serialized_data, type: Hash, default: {}
    def data=(payload)
      if payload.is_a?(String) && payload.starts_with?('<')
        self.write_attribute(:serialized_data, Hash.from_xml(payload))
      elsif payload.is_a?(String)
        self.write_attribute(:serialized_data, JSON.parse(payload))
      elsif payload.is_a?(Hash)
        self.write_attribute(:serialized_data, payload)
      elsif payload.blank?
        self.write_attribute(:serialized_data, {})
      end
    end

    def data
      self.serialized_data
    end

  end
end