# encoding: utf-8
require 'spec_helper'

describe EventFinder do
  let(:project1) { create(:project) }
  let(:project2) { create(:project) }
  let(:event_collection1) { create(:event_collection, project: project1) }
  let(:event_collection2) { create(:event_collection, project: project2) }
  let!(:event) { create(:model3d_loaded, event_collection: event_collection1) }
  let(:event_finder1) { EventFinder.new project1, event_collection1 }
  let(:event_finder2) { EventFinder.new project2, event_collection2 }

  before do
    MongoEvent.__elasticsearch__.refresh_index!
  end

  describe 'attributes' do
    it 'has a paths attributes' do
      event_finder1.project.should eq project1
      event_finder1.event_collection.should eq event_collection1
    end
  end

  describe 'search' do
    it 'search in the project and event_collection' do
      event_finder1.search.count.should eq(1)
      event_finder2.search.count.should eq(0)
    end
  end
end
