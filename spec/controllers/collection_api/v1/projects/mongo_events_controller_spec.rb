require 'spec_helper'

describe CollectionApi::V1::MongoEventsController do
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

  describe "#create" do
    context "when the collection already exist" do
      it "creates a new mongo_event" do
        post :create,
          project_id: project.id,
          event_collection: event_collection.name,
          mongo_event: {data: '{"action": "loaded asset", "time":["test", false, 3.5]}' }
        response.status.should eq 201 # :created
        response.should render_template 'api/v1/mongo_events/create'
        MongoEvent.first.tap do |mongo_event|
          expect(mongo_event.event_collection.name).to eq 'my_event_collection'
          expect(mongo_event.data['action']).to eq 'loaded asset'
          expect(mongo_event.data['time']).to eq ['test', false, 3.5]
        end
      end
    end
    context "when the collection doesn't exist"
    it "create a new collection and mongo_event" do
      post :create,
        project_id: project.id,
        event_collection: 'another_collection',
        mongo_event: { data: '{"action": "loaded asset", "time":["test", false, 3.5]}' }
        response.status.should eq 201 # :created
        response.should render_template 'api/v1/mongo_events/create'
        expect(EventCollection.count).to eq(1)
        MongoEvent.first.tap do |mongo_event|
          expect(mongo_event.event_collection.name).to eq 'another_collection'
          expect(mongo_event.data['action']).to eq 'loaded asset'
          expect(mongo_event.data['time']).to eq ['test', false, 3.5]
        end
    end
  end

  describe "#index" do
    it "shows existing assets" do
      get :index,
      project_id: project.id,
      event_collection: event_collection.name
      response.should render_template 'api/v1/mongo_events/index'
      response.status.should eq 200
    end

    it "return 404 not found" do
      get :index,
        project_id: project.id,
        event_collection: 'another_collection'
      response.should_not render_template 'api/v1/mongo_events/index'
      response.status.should eq 404
    end
  end

  describe "#show" do
    it "shows an existing mongo_event" do
      get :show,
        project_id: project.id,
        event_collection: event_collection.name,
        id: mongo_event.id
      response.should render_template 'api/v1/mongo_events/show'
      response.status.should eq 200
    end
    it "return 404 not found when the collection is not found" do
      get :show,
        project_id: project.id,
        event_collection: 'another_collection',
        id: mongo_event.id
      response.should_not render_template 'api/v1/mongo_events/show'
      response.status.should eq 404
    end
    it "return 404 not found when the mongo_event is not found" do
      get :show,
        project_id: project.id,
        event_collection: event_collection.name,
        id: 'another_mongo_event'
      response.should_not render_template 'api/v1/mongo_events/show'
      response.status.should eq 404
    end
  end

  describe "#destroy" do
    it "destroy an existing mongo_event" do
      delete :destroy,
        project_id: project.id,
        event_collection: event_collection.name,
        id: mongo_event.id
      response.should_not render_template 'api/v1/mongo_events/destroy'
      response.status.should eq 204
      expect { mongo_event.reload }.to raise_error Mongoid::Errors::DocumentNotFound
    end
    it "return 404 not found" do
      delete :destroy,
        project_id: project.id,
        event_collection: 'another_collection',
        id: 'another_mongo_event'
      response.should_not render_template 'api/v1/mongo_events/destroy'
      response.status.should eq 404
    end
  end
end
