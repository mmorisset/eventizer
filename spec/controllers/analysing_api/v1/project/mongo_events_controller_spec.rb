require 'spec_helper'

describe AnalysingApi::V1::MongoEventsController do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:event_collection) { create(:event_collection, name: 'my_event_collection', project: project) }
  let(:mongo_event) { create(:mongo_event, event_collection: event_collection) }

  before do
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
      p response.body
    end
  end

  # describe "#index" do
  #   it "shows existing assets" do
  #     get :index,
  #     project_id: project.id,
  #     event_collection: event_collection.name
  #     response.should render_template 'api/v1/mongo_events/index'
  #     response.status.should eq 200
  #   end

  #   it "return 404 not found" do
  #     get :index,
  #       project_id: project.id,
  #       event_collection: 'another_collection'
  #     response.should_not render_template 'api/v1/mongo_events/index'
  #     response.status.should eq 404
  #   end
  # end

  # describe "#show" do
  #   it "shows an existing mongo_event" do
  #     get :show,
  #       project_id: project.id,
  #       event_collection: event_collection.name,
  #       id: mongo_event.id
  #     response.should render_template 'api/v1/mongo_events/show'
  #     response.status.should eq 200
  #   end
  #   it "return 404 not found when the collection is not found" do
  #     get :show,
  #       project_id: project.id,
  #       event_collection: 'another_collection',
  #       id: mongo_event.id
  #     response.should_not render_template 'api/v1/mongo_events/show'
  #     response.status.should eq 404
  #   end
  #   it "return 404 not found when the mongo_event is not found" do
  #     get :show,
  #       project_id: project.id,
  #       event_collection: event_collection.name,
  #       id: 'another_mongo_event'
  #     response.should_not render_template 'api/v1/mongo_events/show'
  #     response.status.should eq 404
  #   end
  # end

  # describe "#destroy" do
  #   it "destroy an existing mongo_event" do
  #     delete :destroy,
  #       project_id: project.id,
  #       event_collection: event_collection.name,
  #       id: mongo_event.id
  #     response.should_not render_template 'api/v1/mongo_events/destroy'
  #     response.status.should eq 204
  #     expect { mongo_event.reload }.to raise_error Mongoid::Errors::DocumentNotFound
  #   end
  #   it "return 404 not found" do
  #     delete :destroy,
  #       project_id: project.id,
  #       event_collection: 'another_collection',
  #       id: 'another_mongo_event'
  #     response.should_not render_template 'api/v1/mongo_events/destroy'
  #     response.status.should eq 404
  #   end
  # end
end
