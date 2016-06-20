module DataImport
  module HTTP
    extend ActiveSupport::Concern

    included do
      # @attr_reader [Typheous::Hydra] the hydra to queue with
      attr_reader :hydra
      delegate :queue, :run, to: :@hydra
    end

    def initialize(opts = {})
      @hydra = Typhoeus::Hydra.new(max_concurrency: 80) # hail hydra
      super
    end

    private
    def queued
      hydra.queued_requests
    end

    def get(path, opts = {})
      opts = opts.merge(accept_encoding: :gzip)
      req = Typhoeus::Request.new(build_url(path), opts)
      req.on_failure do |res|
        puts "Request failed (#{request_url(res)} => #{res.return_code.to_s})"
      end
      req.on_headers do |res|
        unless res.code == 200
          puts "Request failed (#{request_url(res)} => #{res.status_message})"
        end
      end
      if block_given?
        req.on_complete do |res|
          yield res.body
        end
      end
      queue(req)
      req
    end

    def build_url(path)
      return path if path.include?('://')
      "#{@opts[:host]}#{path}"
    end

    def request_url(res)
      req = res.is_a?(Typhoeus::Response) ? res.request : res
      url = res.is_a?(Typhoeus::Response) ? res.effective_url : res.url
      method = req.options[:method].to_s.upcase
      "#{method} #{url}"
    end
  end
end
