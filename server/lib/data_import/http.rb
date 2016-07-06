module DataImport
  module HTTP
    extend ActiveSupport::Concern

    included do
      # @attr_reader [Typheous::Hydra] the hydra to queue with
      attr_reader :hydra
      delegate :queue, :run, to: :@hydra
    end

    def initialize
      @hydra = Typhoeus::Hydra.new(max_concurrency: 80) # hail hydra
      super
    end

    private

    def queued
      hydra.queued_requests
    end

    def parallel_get(urls, opts = {})
      # This lovely thing handles an array of URLs by repeatly shoving onto an
      # array and then when it has 'em all, it yields the results
      if urls.respond_to?(:each)
        results = Array.new(urls.length)
        return urls.each_with_index do |url, i|
          get(url, opts) do |res|
            results[i] = res
            yield(*results) if results.compact.length == urls.length
          end
        end
      end
    end

    def get(url, opts = {})
      opts = opts.merge(accept_encoding: :gzip)
      req = Typhoeus::Request.new(url, opts)
      req.on_failure do |res|
        message = res.return_code.to_s
        $stderr.puts "Request failed (GET #{request_url(res)} => #{message})"
      end
      req.on_headers do |res|
        unless res.code == 200
          message = res.status_message
          $stderr.puts "Request failed (GET #{request_url(res)} => #{message})"
        end
      end
      req.on_complete do |res|
        yield res.body if res.code == 200
      end if block_given?
      queue(req)
      req
    end

    def request_url(res)
      res.respond_to?(:effective_url) ? res.effective_url : res.url
    end
  end
end
