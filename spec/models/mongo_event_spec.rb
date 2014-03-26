require 'spec_helper'

describe MongoEvent do

  describe "Factory" do
    it { build(:mongo_event).should be_valid }
  end

  describe "Attributes" do
    it { should have_field(:serialized_data).of_type(Hash) }
    it { should be_timestamped_document }
  end

  describe "Associations" do
    it { should belong_to(:event_collection).as_inverse_of(:mongo_events)}
  end

  describe "Validations" do
    it { should validate_presence_of(:event_collection) }
  end
end