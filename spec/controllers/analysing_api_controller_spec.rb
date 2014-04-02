require 'spec_helper'

describe AnalysingApiController do
  before :all do
    AnalysingApiController.send(:define_method, :show) do
      raise('I am executed')
    end

    Rails.application.routes.draw do
      match '/show', controller: 'analysing_api', action: 'show'
    end
  end

  after :all do
    require Rails.application.root.join('config/routes')
    AnalysingApiController.send :remove_method, :show
  end

  describe "#current_user" do
    before do
      @current_user = create(:user)
      controller.instance_variable_set :@current_user, @current_user
    end

    it "should return an instance of the current user" do
      controller.current_user.should eq @current_user
    end
  end

  describe "#current_project" do
    before do
      @current_project = create(:project)
      controller.instance_variable_set :@current_project, @current_project
    end

    it "should return an instance of the current user" do
      controller.current_project.should eq @current_project
    end
  end

  describe "#current_event_collection" do
    before do
      @current_event_collection = create(:event_collection)
      controller.instance_variable_set :@current_event_collection, @current_event_collection
    end

    it "should return an instance of the current user" do
      controller.current_event_collection.should eq @current_event_collection
    end
  end

  describe '#authenticate_user!' do
    it 'sends back a 400 \'Required parameter missing: secret\' if user secret is missing when requested' do
      get :show
      response.body.should include "Required parameter missing: secret"
      response.status.should eq 400
    end

    it 'sends back a 401 \'Unrecognized User Authorization: Access denied\' if user cannot be found' do
      get :show, { secret: 'invalid-secret' }
      response.body.should include "Unrecognized User Authorization: Access denied"
      response.status.should eq 401
    end
  end

  describe '#identify_project!' do

    let(:user) { create(:user) }
    let(:project) { create(:project, user: user) }

    before do
      controller.stub(:authenticate_user!) { true }
      controller.stub(:authorize_access!) { true }
      controller.instance_variable_set :@current_user, user
    end

    it 'sends back a 400 \'Required parameter missing: project\' if user project is missing when requested' do
      get :show
      response.body.should include "Required parameter missing: project"
      response.status.should eq 400
    end

    it 'sends back a 404 \'Unrecognized Project: Access denied\' if project cannot be found' do
      get :show, { project_id: 'invalid-project' }
      response.status.should eq 404
    end
  end


  describe '#identify_event_collection!' do

    let(:user) { create(:user) }
    let(:project) { create(:project, user: user) }
    let(:event_collection) { create(:event_collection, project: project) }

    before do
      controller.stub(:authenticate_user!) { true }
      controller.stub(:authorize_access!) { true }
      controller.stub(:identify_project!) { true }
      controller.instance_variable_set :@current_user, user
      controller.instance_variable_set :@current_project, project
    end

    it 'sends back a 400 \'Required parameter missing: event_collection\' if event_collection is missing when requested' do
      get :show
      response.body.should include "Required parameter missing: event_collection"
      response.status.should eq 400
    end

    it 'sends back a 404 \'Unrecognized EventCollection: Access denied\' if event_collection cannot be found' do
      get :show, { event_collection: 'invalid-event_collection' }
      response.status.should eq 404
    end
  end

  describe '#create_event_finder!' do

    let(:user) { create(:user) }
    let(:project) { create(:project, user: user) }
    let(:event_collection) { create(:event_collection, project: project) }

    before do
      controller.stub(:authenticate_user!) { true }
      controller.stub(:authorize_access!) { true }
      controller.stub(:identify_project!) { true }
      controller.stub(:identify_event_collection!) { true }
      controller.instance_variable_set :@current_user, user
      controller.instance_variable_set :@current_project, project
      controller.instance_variable_set :@current_event_collection, event_collection
    end

    it 'creates the event finder' do
      expect { get :show }.to raise_error 'I am executed'
      controller.current_event_finder.should_not be_nil
      controller.current_event_finder.project.should eq project
      controller.current_event_finder.event_collection.should eq event_collection

    end
  end
end