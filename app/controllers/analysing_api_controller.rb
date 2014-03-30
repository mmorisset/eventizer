class AnalysingApiController < ActionController::Base
  include ActionController::MimeResponds
  before_filter do
    request.format = "json"
  end

  respond_to :json
  self.responder = CustomResponder

  before_filter :authenticate_user!
  before_filter :authenticate_project!

  helper_method :current_user

  def current_user
    @current_user
  end

  def current_project
    @current_project
  end

  # https://github.com/aq1018/mongoid-history/issues/26
  around_filter do |controller, action|
    Thread.current[:mongoid_history_sweeper_controller] = self
    action.call
    Thread.current[:mongoid_history_sweeper_controller] = nil
  end

  rescue_from Mongoid::Errors::DocumentNotFound, :with => :resource_not_found # 404

  rescue_from(ActionController::ParameterMissing) do |parameter_missing_exception|
    respond_with({ error: "Required parameter missing: #{parameter_missing_exception.param}" }, status: :bad_request, location: nil, template: nil)
  end

  private

    def resource_not_found(exception)
      message = not(Rails.env.production?) ?
        exception.message.split('Summary:').first.
          gsub("\nProblem:\n  ", '').
          gsub("Document(s) not found for class ", '').
          gsub("Document not found for class ", '').
          gsub(" with attributes ", ' ').
          chop.
          chomp('.') + ' not found' :
        'resource not found'
      respond_with({ error: message }, status: :not_found, location: nil, template: nil) && return
    end

    def authenticate_user!
      if authorization = Authorization.where(secret: params.require(:secret)).first
        @current_user = authorization.user
      else
        respond_with({ error: "Unrecognized User Authorization: Access denied" }, status: :unauthorized, location: nil, template: nil)
        return false
      end
    end

    def authenticate_project!
      unless @current_project = @current_user.projects.find(params.require(:project_id))
        respond_with({ error: "Unrecognized User Authorization: Access denied" }, status: :not_found, location: nil, template: nil)
        return false
      end
    end
end
