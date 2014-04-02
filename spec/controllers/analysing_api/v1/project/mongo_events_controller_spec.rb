require 'spec_helper'

describe AnalysingApi::V1::MongoEventsController do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:event_collection) { create(:event_collection, name: 'my_event_collection', project: project) }
  let!(:mongo_event) { create(:model3d_loaded, event_collection: event_collection) }

  before do
    MongoEvent.__elasticsearch__.refresh_index!
    controller.stub(:authenticate_user!) { true }
    controller.stub(:authorize_access!) { true }
    controller.stub(:authenticate_project!) { true }
    controller.instance_variable_set :@current_user, user
    controller.instance_variable_set :@current_project, project
  end

  describe "#count" do
    it "counts the number of mongo_events" do
      get :count,
        project_id: project.id,
        event_collection: event_collection.name
      response.status.should eq 200
      JSON.parse(response.body)["result"].should == 1
    end
  end
end
