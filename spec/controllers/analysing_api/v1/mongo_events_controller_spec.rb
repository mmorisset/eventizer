require 'spec_helper'

describe AnalysingApi::V1::MongoEventsController do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:event_collection) { create(:event_collection, name: 'my_event_collection', project: project) }
  let!(:mongo_event) { create(:model3d_loaded, event_collection: event_collection, created_at: Chronic.parse('an hour ago')) }

  before do
    MongoEvent.__elasticsearch__.refresh_index!
    controller.stub(:authenticate_user!) { true }
    controller.stub(:authorize_access!) { true }
    controller.stub(:authenticate_project!) { true }
    controller.instance_variable_set :@current_user, user
    controller.instance_variable_set :@current_project, project
  end

  describe "#count" do
    context "when no interval is given" do
      it "should counts the number of all mongo_events" do
        get :count,
          project_id: project.id,
          event_collection: event_collection.name
        response.status.should eq 200
        JSON.parse(response.body)["result"].should eq(1)
      end
    context "when an timeframe is given"
      it "should count the number of mongo_events in the timeframe" do
        get :count,
          project_id: project.id,
          event_collection: event_collection.name,
          timeframe: {
            start_time: Time.now - 2.hours,
            end_time: Time.now
          }
        response.status.should eq 200
        JSON.parse(response.body)["result"].should eq(1)
      end
      it "should not count the number of mongo_events outside the timeframe" do
        get :count,
          project_id: project.id,
          event_collection: event_collection.name,
          timeframe: {
            start_time: Time.now - 4.hours,
            end_time: Time.now - 2.hours
          }
        response.status.should eq 200
        JSON.parse(response.body)["result"].should eq(0)
      end
      it "should not count the number of mongo_events outside the timeframe" do
        get :count,
          project_id: project.id,
          event_collection: event_collection.name,
          timeframe: {
            start_time: Time.now - 4.hours,
            end_time: Time.now - 2.hours
          }
        response.status.should eq 200
        JSON.parse(response.body)["result"].should eq(0)
      end
    end
    context "when an interval is given"
      it "should count the number of mongo_events in the timeframe" do
        get :count,
          project_id: project.id,
          event_collection: event_collection.name,
          interval: 'hour'
        response.status.should eq 200
        JSON.parse(response.body)["results"].size.should eq(1)
      end
  end
end
