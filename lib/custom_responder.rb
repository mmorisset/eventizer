class CustomResponder < ActionController::Responder

  def api_behavior(error)
    raise error unless resourceful?

    if get?
      display resource
    elsif post?
      display resource, :status => :created, :location => api_location
    else
      display "", :status => :no_content # instead of head :no_content in rails, which garbles every errors happening prior
    end
  end
end