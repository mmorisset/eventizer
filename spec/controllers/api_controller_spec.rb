require 'spec_helper'

describe ApiController do
  before :all do
    ApiController.send(:define_method, :create) do
      raise('I am executed')
    end
    ApiController.send(:define_method, :show) do
      raise('I am executed')
    end

    ApiController.send(:define_method, :index) do
      raise('I am executed')
    end

    ApiController.send(:define_method, :update) do
      raise('I am executed')
    end

    ApiController.send(:define_method, :delete) do
      raise('I am executed')
    end

    Rails.application.routes.draw do
      match '/show', controller: 'api', action: 'create'
      match '/show', controller: 'api', action: 'show'
      match '/index', controller: 'api', action: 'index'
      match '/update', controller: 'api', action: 'update'
      match '/delete', controller: 'api', action: 'delete'
    end
  end

  after :all do
    require Rails.application.root.join('config/routes')
    ApiController.send :remove_method, :create
    ApiController.send :remove_method, :show
    ApiController.send :remove_method, :index
    ApiController.send :remove_method, :update
    ApiController.send :remove_method, :delete
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

  describe "#current_authorization" do
    before do
      @current_authorization = create(:authorization)
      controller.instance_variable_set :@current_authorization, @current_authorization
    end

    it "should return an instance of the current authorization" do
      controller.current_authorization.should eq @current_authorization
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

  describe '#authorize_access!' do
    let(:user) { create(:user) }
    let(:write_authorization) { create(:write_authorization, user: user) }
    let(:read_authorization) { create(:read_authorization, user: user) }

    before do
      controller.stub(:authenticate_project!) { true }
    end

    context 'when the authorization has no write access' do
      it 'allows read access' do
        expect { get :index,  { secret: write_authorization.secret } }.to raise_error 'I am executed'
        expect { get :show,   { secret: write_authorization.secret } }.to raise_error 'I am executed'
      end

      it 'doesn\'t allow write access' do
        get :create, { secret: read_authorization.secret }
        response.body.should include "Insufficient access rights: Access denied"
        response.status.should eq 403
        get :update, { secret: read_authorization.secret }
        response.body.should include "Insufficient access rights: Access denied"
        response.status.should eq 403
        get :delete, { secret: read_authorization.secret }
        response.body.should include "Insufficient access rights: Access denied"
        response.status.should eq 403
      end
    end

    context 'when the authorization has write access' do
      it 'allows write access' do
        expect { get :index,  { secret: write_authorization.secret } }.to raise_error 'I am executed'
        expect { get :show,   { secret: write_authorization.secret } }.to raise_error 'I am executed'
        expect { get :create, { secret: write_authorization.secret } }.to raise_error 'I am executed'
        expect { get :update, { secret: write_authorization.secret } }.to raise_error 'I am executed'
        expect { get :delete, { secret: write_authorization.secret } }.to raise_error 'I am executed'
      end
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