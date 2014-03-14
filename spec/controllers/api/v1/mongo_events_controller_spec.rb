require 'spec_helper'

describe Api::V1::MongoEventsController do

  before do
    controller.stub(:authenticate_user!) { true }
    controller.stub(:authorize_access!) { true }
    @current_user = create(:user)
    controller.instance_variable_set :@current_user, @current_user
  end

  describe "#create" do
    it "creates a new mongo_event" do

      post :create, { mongo_event: { data: '{"action": "loaded asset", "time":["test", false, 3.5]}' } }
      response.status.should eq 201 # :created
      response.should render_template 'api/v1/mongo_events/create'

      MongoEvent.first.tap do |mongo_event|
        expect(mongo_event.data['action']).to eq 'loaded asset'
        expect(mongo_event.data['time']).to eq ['test', false, 3.5]
      end
    end
  end

  describe "#index" do
    let!(:mongo_event_1) { create(:mongo_event, user: @current_user) }

    it "shows existing assets" do
      get :index
      response.should render_template 'api/v1/mongo_events/index'
      response.status.should eq 200
    end
  end

  describe "#show" do
    let!(:mongo_event) { create(:mongo_event, user: @current_user) }

    it "shows an existing mongo_event" do

      get :show, id: mongo_event.id
      response.should render_template 'api/v1/mongo_events/show'
      response.status.should eq 200
    end 
  end

  describe "#destroy" do
    let!(:mongo_event) { create(:mongo_event, user: @current_user) }

    it "destroy an existing mongo_event" do
      delete :destroy, id: mongo_event.id
      response.should_not render_template 'api/v1/mongo_events/destroy'
      response.status.should eq 204
      expect { mongo_event.reload }.to raise_error Mongoid::Errors::DocumentNotFound
    end
  end
end
