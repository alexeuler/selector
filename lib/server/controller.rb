require_relative "../selector"

class Controller
  def call(env)
    params = params(env)
    user_id = params["user_id"].to_i
    Selector::select(user_id) if user_id>0
    [200, {}, []]
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