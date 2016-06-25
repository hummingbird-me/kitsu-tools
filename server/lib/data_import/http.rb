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
        results = []
        return urls.each do |url|
          get(url, opts) do |res|
            results << res
            yield *results if results.length == urls.length
          end
        end
      end
    end

    def get(url, opts = {})
      opts = opts.merge(accept_encoding: :gzip)
      req = Typhoeus::Request.new(url, opts)
      req.on_failure do |res|
        puts "Request failed (#{request_url(res)} => #{res.return_code.to_s})"
      end
      req.on_headers do |res|
        unless res.code == 200
          puts "Request failed (#{request_url(res)} => #{res.status_message})"
        end
      end
      req.on_complete { |res| yield res.body } if block_given?
      queue(req)
      req
    end

    def request_url(res)
      req = res.is_a?(Typhoeus::Response) ? res.request : res
      url = res.is_a?(Typhoeus::Response) ? res.effective_url : res.url
      method = req.options[:method].to_s.upcase
      "#{method} #{url}"
    end
  end
end
