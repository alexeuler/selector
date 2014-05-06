require_relative "../selector"

class Controller
  def call(env)
    request=Rack::Request.new(env)
    user_id=request.GET["user_id"]
    Selector::select(user_id)
    response=Rack::Response.new
    response.finish
    response
  end
end