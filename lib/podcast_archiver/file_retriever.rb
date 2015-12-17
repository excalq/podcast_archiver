require 'net/http'
require_relative '_url_multi_queue'

module PodcastArchiver
  class FileRetriever

    DEFAULT_MAX_CONCURRENCY = 10
    @download_queue # Instance of UrlMultiQueue
    @download_threads # Array of threads

    def initialize(max_concurrency = DEFAULT_MAX_CONCURRENCY)
      @download_threads = []
      @download_queue = UrlMultiQueue.new(max_concurrency)
    end

    # Creates threads having a persistent connection unique to a host+port
    # All urls are queued for download
    def download(url, dest_dir)
      @download_queue << url

      thread = Thread.new do
        sleep 1 while @download_queue.max_exceeded?(url)

        if @download_queue.connection_id(url) == :local
          open('local-file.txt') { |f| f.read }
        else
          host = URI(url).host # TODO: is #hostname better for ipv6 addrs?
          port = URI(url).port
          uri = URI(url)

          Net::HTTP.start(host, port) do |http|
            request = Net::HTTP::Get.new(uri)
            response = http.request request
            write_file url, response.body, dest_dir
          end
        end

      end

      @download_threads << thread
    end

    def write_file(url, data, dest_dir)

    end



  end
end
