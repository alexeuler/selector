require 'ruby-prof'
require_relative "../selector"

class Controller
  def call(env)
    #RubyProf.start
    puts "#{Time.now}: Received request: #{env['REQUEST_URI']}"
    params = params(env)
    task = task(env)
    case task
      when "train"
        user_id=params["user_id"].to_i
        return [200, {}, ["Invalid user_id: #{user_id}"]] if user_id <=0
        train(user_id)
    end

    puts "#{Time.now}: Done"
    # result = RubyProf.stop
    # printer = RubyProf::GraphHtmlPrinter.new(result)
    # File.open(App.root+"/profiling/profile.html", "w") {|file| printer.print(file)}
    [200, {}, []]
  end

  def train(user_id)
    Selector::select(user_id) if user_id>0
  end

  private

  def params(env)
    data = env["QUERY_STRING"].split("&")
    hash = {}
    data.each do |tuple|
      key, value = tuple.split("=")
      hash[key] = value
    end
    hash
  end

  def task(env)
    env["REQUEST_PATH"][1..-1]
  end
end