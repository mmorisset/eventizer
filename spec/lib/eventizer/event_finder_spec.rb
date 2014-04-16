# encoding: utf-8
require 'spec_helper'

describe EventFinder do

  describe 'attributes' do
    let(:project) { create(:project) }
    let(:event_collection) { create(:event_collection, project: project) }
    let(:timeframe) {{"start_time" => "#{Time.now - 2.hours}", "end_time" => "#{Time.now}"}}
    let(:filters) { [{"name" => "test_event"}] }
    let(:event_finder) { EventFinder.new project, event_collection, filters, timeframe, 'hour' }
    it 'has a paths attributes' do
      event_finder.project.should eq project
      event_finder.event_collection.should eq event_collection
      event_finder.filters.should eq filters
      event_finder.timeframe.should eq timeframe
      event_finder.interval.should eq 'hour'
    end
  end

  describe 'count' do
    context 'when nothing is given' do
      let(:project) { create(:project) }
      let(:event_collection) { create(:event_collection, project: project) }
      let!(:event) { create(:model3d_loaded, event_collection: event_collection, created_at: Time.now - 1.hours) }
      let(:event_finder) { EventFinder.new project, event_collection }

      let(:another_project) { create(:project) }
      let(:another_event_collection) { create(:event_collection, project: another_project) }
      let(:another_event_finder) { EventFinder.new another_project, another_event_collection }

      before do
        MongoEvent.__elasticsearch__.refresh_index!
      end

      it 'searchs in the given project and event_collection' do
        JSON.parse(event_finder.count)['result'].should eq(1)
        JSON.parse(another_event_finder.count)['result'].should eq(0)
      end
    end

    context 'when a timeframe is given' do
      let(:project) { create(:project) }
      let(:event_collection) { create(:event_collection, project: project) }
      let!(:event) { create(:model3d_loaded, event_collection: event_collection, created_at: Time.now - 1.hours) }
      let(:timeframe) { {"start_time" => "#{Time.now - 2.hours}", "end_time" => "#{Time.now}"} }
      let(:event_finder) { EventFinder.new project, event_collection, nil, timeframe }
      
      let(:another_timeframe) { {"start_time" => "#{Time.now - 4.hours}", "end_time" => "#{Time.now - 2.hours}"} }
      let(:another_event_finder) { EventFinder.new project, event_collection, nil, another_timeframe }

      before do
        MongoEvent.__elasticsearch__.refresh_index!
      end

      it 'searchs in the given timeframe' do
        JSON.parse(event_finder.count)['result'].should eq(1)
        JSON.parse(another_event_finder.count)['result'].should eq(0)
      end
    end

    context 'when an interval is given' do
      let(:project) { create(:project) }
      let(:event_collection) { create(:event_collection, project: project) }
      let!(:event1) { create(:model3d_loaded, event_collection: event_collection, created_at: Time.now - 1.minutes) }
      let!(:event2) { create(:model3d_loaded, event_collection: event_collection, created_at: Time.now - 2.minutes) }
      let!(:event3) { create(:model3d_loaded, event_collection: event_collection, created_at: Time.now - 3.minutes) }
      let(:timeframe) { {"start_time" => "#{Time.now - 1.hours}", "end_time" => "#{Time.now}"} }
      let(:event_finder) { EventFinder.new project, event_collection, nil, timeframe, 'minute'}

      before do
        MongoEvent.__elasticsearch__.refresh_index!
      end

      it 'searchs with the given interval' do
        JSON.parse(event_finder.count)['results'].size.should eq(3)
      end
    end

    context 'when filters are given' do
      let(:project) { create(:project) }
      let(:event_collection) { create(:event_collection, project: project) }
      let!(:event1) { create(:mongo_event, event_collection: event_collection, data: {name: 'ab', times: {load: 20, display: 40}}) }
      let!(:event2) { create(:mongo_event, event_collection: event_collection, data: {name: 'ab', times: {load: 20, display: 40}}) }
      let!(:event3) { create(:mongo_event, event_collection: event_collection, data: {name: 'cd', times: {load: 10, display: 40}}) }
      
      let(:filters1) { [{"field" => "data.times.load", "operator" => "gt", "value" => 15}] }
      let(:event_finder1) { EventFinder.new project, event_collection, filters1, nil, nil }

      let(:filters2) { [{"field" => "data.times.load", "operator" => "lt", "value" => 15}] }
      let(:event_finder2) { EventFinder.new project, event_collection, filters2, nil, nil }

      let(:filters3) { [{"field" => "data.times.load", "operator" => "gte", "value" => 10}] }
      let(:event_finder3) { EventFinder.new project, event_collection, filters3, nil, nil }

      let(:filters4) { [{"field" => "data.times.load", "operator" => "lte", "value" => 20}] }
      let(:event_finder4) { EventFinder.new project, event_collection, filters4, nil, nil }

      let(:filters5) { [{"field" => "data.name", "operator" => "lt", "value" => "cd"}] }
      let(:event_finder5) { EventFinder.new project, event_collection, filters5, nil, nil }

      let(:filters6) { [{"field" => "data.name", "operator" => "gt", "value" => "ab"}] }
      let(:event_finder6) { EventFinder.new project, event_collection, filters6, nil, nil }

      before do
        MongoEvent.__elasticsearch__.refresh_index!
      end
      
      it 'searchs with the given filters' do
        JSON.parse(event_finder1.count)['result'].should eq(2)
        JSON.parse(event_finder2.count)['result'].should eq(1)
        JSON.parse(event_finder3.count)['result'].should eq(3)
        JSON.parse(event_finder4.count)['result'].should eq(3)
        JSON.parse(event_finder5.count)['result'].should eq(2)
        JSON.parse(event_finder6.count)['result'].should eq(1)
      end
    end
  end
end
