# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event_collection do
    sequence(:name) { |n| "event_collection_#{n}" }
    project { build(:project) }
  end
end
