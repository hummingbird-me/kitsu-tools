module DataImport
  class Hummingbird
    attr_reader :hydra
    delegate :queue, :run, to: :@hydra

    # Create a new Hummingbird data import processor
    def initialize(opts = {})
      @opts = opts.with_indifferent_access
      @hydra = Typhoeus::Hydra.new(max_concurrency: 80) # hail hydra
    end

    # Retrieve the Hydra queue
    def queued
      hydra.queued_requests
    end

    # get a bunch of anime
    def get_anime(ids)
      fail 'Must use APIv2' unless apiv2?
      ids = [ids] unless ids.is_a? Array

      ids.each_slice(100) do |batch|
        req = get("/api/v2/anime/#{batch.join(',')}", headers: {
          'X-Client-Id' => client_id
        })
        req.on_complete do |res|
          begin
            anime = JSON.parse(res.body)['anime']
            anime.each { |a| yield a }
          rescue
            get_anime(ids, &Proc.new)
          end
        end
      end
    end

    # Get a bunch of posters
    def download_posters(ids)
      ids = [ids] unless ids.is_a? Array

      get_anime(ids) do |anime|
        file = Tempfile.new("anime_#{anime['id']}")
        file.binmode
        req = get(anime['poster_image'].sub('https:', 'http:'))
        req.on_complete { |res| file.write(res.body); yield anime, file.flush }
      end
    end

    private

    def client_id
      #@opts[:client_id]
      '284b9b980a2b3d0749bb'
    end

    def apiv2?
      client_id.present?
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
