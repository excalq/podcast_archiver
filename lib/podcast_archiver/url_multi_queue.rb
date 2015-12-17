require 'uri'

# Container Structure for Queued URLs which will be
# processed in a shared persistent connection.
# As each connection is specific to a host+port (its connection_id)
# These URLs are Queued into a Hash, keyed by their host+port
# Use #max_exeeded? to test if the host's Queue excceds +max_concurrency+

module PodcastArchiver
  class UrlMultiQueue

    @host_queues # Hash of Queues, keyed by host+port
    @max_concurrency

    # +max_concurrency+ is the maximum allowed concurrent requests
    #   allowed per host+port persistent connection
    def initialize(max_concurrency)
      @max_concurrency = max_concurrency
      @host_queues = {}
    end

    def push(url)
      connection_id = self.connection_id(url)
      unless @host_queues.has_key?(connection_id.to_sym)
        @host_queues[connection_id.to_sym] = Queue.new
      end

      @host_queues[connection_id.to_sym].push(url)
    end

    def pop(connection_id)
      @host_queues[connection_id.to_sym].pop if @host_queues.has_key?(connection_id.to_sym)
    end

    def num_queued(connection_id)
      if @host_queues.has_key?(connection_id.to_sym)
        @host_queues[connection_id.to_sym].length
      else
        0
      end
    end

    def max_exceeded?(url)
      connection_id = self.connection_id(url)
      if @host_queues.has_key?(connection_id.to_sym)
        @host_queues[connection_id.to_sym].length > @max_concurrency
      else
        false
      end
    end

    def connection_id(url)
      self.class.connection_id(url)
    end

    def self.connection_id(url)
      return :local if URI(url).hostname.nil?
      (URI(url).hostname + URI(url).port.to_s).gsub(/[^0-9a-z ]/i, '').to_sym
    end

    alias_method :<<, :push
  end
end