module Rack
  class Indexable
    CRAWLER_USER_AGENTS = [
      /^Twitterbot/, /^curl/, /Googlebot/, /Mediapartners/, /Adsbot-Google/
    ]

    def initialize(app)
      @app = app
    end

    # Detect whether the current request comes from a bot. Based on the logic used
    # by Bustle.com (https://www.dropbox.com/s/s4oibqsxqpo3hll/bustle%20slizzle.pdf)
    def request_from_crawler?(env)
      user_agent  = env["HTTP_USER_AGENT"]
      params      = Rack::Request.new(env).params
      return false  unless user_agent
      return true   if CRAWLER_USER_AGENTS.any? {|s| user_agent.match(s) }
      return true   if params.has_key?('_escaped_fragment_')
      user_agent.match(/\(.*https?:\/\/.*\)/) || params['nojs'].eql?('true')
    end

    def call(env)
      status, headers, content = *@app.call(env)

      if status == 200 and headers['Content-Type'].match(/^text\/html/) and request_from_crawler?(env)
        script = ::File.dirname(__FILE__) + "/render_page.js"
        file = Tempfile.new(['indexable', '.html'])
        file.write content.body
        file.close
        begin
          url = Rack::Request.new(env).url
          content = [Phantomjs.run(script, file.path, url)]
          status = 500 if content[0] == "Couldn't render page... orz."
        ensure
          file.unlink
        end
      end

      [status, headers, content]
    end
  end
end
