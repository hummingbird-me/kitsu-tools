class LogBeforeTimeout
  def initialize(app)
    @app = app
  end

  def call(env)
    thr = Thread.new do
      sleep(17)

      path = env["PATH_INFO"]
      qs = env["QUERY_STRING"] and path = "#{path}?#{qs}"
      Rails.logger.warn "#{path} I’m about to timeout bringing down my unicorn worker too :("
    end
    @app.call(env)
  ensure
    thr.exit
  end
end
