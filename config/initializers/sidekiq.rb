if true
  require 'json'

  class ObjectSpaceSidekiqMiddleware
    def call(worker, job, queue)
      @@logger ||= Logger.new '/tmp/sidekiq_mem.log'
      
      GC.start
      initial_memory = `ps -o rss= -p #{Process.pid}`.to_i
      
      yield
      
      GC.start
      final_memory = `ps -o rss= -p #{Process.pid}`.to_i

      report = {}
      report[:memory_delta] = final_memory - initial_memory
      report[:class]        = job["class"]
      report[:args]         = job["args"]
      report[:time]         = Time.now

      @@logger.info report.to_json
    end
  end

  Sidekiq.configure_server do |config|
    config.server_middleware do |chain|
      chain.add ObjectSpaceSidekiqMiddleware
    end
  end
end
