require_relative "../selector"

class Controller
  def call(env)
    params = params(env)
    user_id = params["user_id"].to_i
    Selector::select(user_id)
    response=Rack::Response.new
    response.finish
    response
  end

  def params(env)
    data = env["QUERY_STRING"].split("&")
    hash = {}
    data.each do |tuple|
      key, value = tuple.split("=")
      hash[key] = value
    end
    hash
  end
end