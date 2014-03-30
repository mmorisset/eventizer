require 'spec_helper'

describe CollectionApiController do
  before :all do
    CollectionApiController.send(:define_method, :create) do
      raise('I am executed')
    end
    CollectionApiController.send(:define_method, :show) do
      raise('I am executed')
    end

    CollectionApiController.send(:define_method, :index) do
      raise('I am executed')
    end

    CollectionApiController.send(:define_method, :update) do
      raise('I am executed')
    end

    CollectionApiController.send(:define_method, :delete) do
      raise('I am executed')
    end

    Rails.application.routes.draw do
      match '/create', controller: 'collection_api', action: 'create'
      match '/show', controller: 'collection_api', action: 'show'
      match '/index', controller: 'collection_api', action: 'index'
      match '/update', controller: 'collection_api', action: 'update'
      match '/delete', controller: 'collection_api', action: 'delete'
    end
  end

  after :all do
    require Rails.application.root.join('config/routes')
    CollectionApiController.send :remove_method, :create
    CollectionApiController.send :remove_method, :show
    CollectionApiController.send :remove_method, :index
    CollectionApiController.send :remove_method, :update
    CollectionApiController.send :remove_method, :delete
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

  describe '#authenticate_project!' do

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
end