class ApplicationController < ActionController::Base
  protect_from_forgery

  def after_sign_in_path_for(resource_or_scope)
    if params[:return_to].present?
      session[:return_to] = params[:return_to]
    elsif session[:return_to].present?
      session[:return_to]
    else
      '/admin'
    end
  end
end
