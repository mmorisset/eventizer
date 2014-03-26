require 'spec_helper'

describe EventCollection do

  describe "Factory" do
    it { build(:event_collection).should be_valid }
  end

  describe 'fields' do
    it { should have_field(:name).of_type(String) }
  end
  
  describe 'validations' do
    it { should validate_uniqueness_of(:name).scoped_to(:project_id) }
    it { should validate_presence_of(:project) }
  end

  describe "Associations" do
    it { should belong_to(:project).as_inverse_of(:event_collections)}
    it { should have_many(:mongo_events).as_inverse_of(:event_collection) }
  end
end
