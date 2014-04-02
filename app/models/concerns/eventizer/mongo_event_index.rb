module Eventizer::MongoEventIndex
  extend ActiveSupport::Concern

  # Custom index settings for elastic search
  INDEX_SETTINGS = {
    analysis: {
      analyzer: {
        normalized: {
          tokenizer: "keyword",
          filter:  %w{asciifolding lowercase},
          type: "custom"
        },
        all_normalized: {
          tokenizer: "standard",
          filter:  %w{asciifolding lowercase},
          type: "custom"
        }
      }
    }
  }

  included do
    settings INDEX_SETTINGS do
      mapping  "_all" => {
        enabled: true,
        index: :analyzed,
        analyzer: :all_normalized
      },
      "dynamic_templates" => [
          template: {
            match: "*",
            match_mapping_type: "string",
            mapping: {
              type: "multi_field",
              fields: {
                "{name}" => {
                  type: :string,
                  index: :analyzed,
                  analyzer: :normalized,
                  null_value: :null
                }
              }
            }
          }
        ] do

        indexes :id,                  type: :string, index: :not_analyzed
        indexes :event_collection,    type: :string, analyzer: :normalized
        indexes :event_collection_id, type: :string, index: :not_analyzed
        indexes :project_id,          type: :string, index: :not_analyzed
        indexes :created_at,          type: 'date', include_in_all: false
        indexes :data,                type: :object, index: :not_analyzed

      end
    end

    def to_hash
      {
        id:                   self.id.to_s,
        event_collection:     self.event_collection.name,
        event_collection_id:  self.event_collection.id,
        project_id:           self.event_collection.project_id.to_s,
        created_at:           self.created_at,
        data:                 self.data
      }
    end

    def as_indexed_json(options={})
      'p index bitch !!!'
      self.to_hash.to_json
    end
  end
end
