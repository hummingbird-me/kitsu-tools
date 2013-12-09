module Rack
  class Indexable
    def initialize(app)
      @app = app
    end

    # Detect whether the current request comes from a bot. Same logic as used by
    # Bustle.com. (https://www.dropbox.com/s/s4oibqsxqpo3hll/bustle%20slizzle.pdf)
    def request_from_crawler?(env)
      user_agent  = env["HTTP_USER_AGENT"]
      params      = Rack::Request.new(env).params
      return false  unless user_agent
      return true   if user_agent.match(/^Twitterbot/)
      return true   if user_agent.match(/^curl/)
      return true   if params.has_key?('_escaped_fragment_')
      user_agent.match(/\(.*https?:\/\/.*\)/) || params['nojs'].eql?('true')
    end

    def call(env)
      if request_from_crawler?(env)
        script = ::File.dirname(__FILE__) + "/render_page.js"
        url = "http://" + env["HTTP_HOST"] + env["REQUEST_PATH"]
        response = JSON.parse(Phantomjs.run(script, url))
        Rack::Response.new([response["content"]], response["status"]).finish
      else
        @app.call(env)
      end
    end
  end
end
