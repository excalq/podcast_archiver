require 'rss'
require 'open-uri'

module PodcastArchiver
  class RssHandler < Enumerable

    @options
    @feed_start_url

    # TODO: Support pagination!

    def initialize(url, options={})
      @options = OptionsStruct.new(*options.values_at(*OptionsStruct.members))
      @feed_start_url = url
      self
    end

    def each

    end

    # this will probably go away
    def read_all_items
      open(@feed_start_url) do |rss|
        feed = RSS::Parser.parse(rss)
        puts "Title: #{feed.channel.title}" unless @options.quiet
        feed.items.each do |item|
          puts "Item: #{item.title}" unless @options.quiet
        end
      end

    end
  end
end
