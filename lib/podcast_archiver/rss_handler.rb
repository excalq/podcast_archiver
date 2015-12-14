require 'rss'
require 'open-uri'

module PodcastArchiver
  class RssHandler
    include Enumerable

    # TODO: Support pagination

    def initialize(url, options={})
      @options = OptionsStruct.new(*options.values_at(*OptionsStruct.members))
      @feed_metadata = {}
      @feed_items = []
      @feed_start_url = url
      parse
    end

    def each(&block)
      @feed_items.each(&block)
    end

    def parse
      begin
        open(@feed_start_url) do |rss|
          feed = RSS::Parser.parse(rss)

          if feed.channel
            @feed_metadata[:title] = feed.channel.title
            @feed_metadata[:link] = feed.channel.link
            @feed_metadata[:description] = feed.channel.description
          end

          feed.items.each do |item|
            @feed_items << item
          end
        end
      rescue => ex # IOEx and Parse Ex??
        puts "Error parsing feed."
        raise ex
        #puts ex.message
        #puts ex.backtrace
      end
    end

    # returns a hash of metadata + items array of hashes
    # This is particularly useful for testing parse results
    def get_contents
      @feed_metadata.merge({items: @feed_items.map{ |i| get_item_contents(i) } })
    end

    # Returns a hash from an RSS::Channel::Item
    def get_item_contents(item)
      item_elems = {}
      item.instance_variables.each do |iv|
        next if iv == :@do_validate
        key = iv.to_s.sub('@','').to_sym
        val = item.instance_variable_get(iv)
        item_elems[key] = val unless val.nil? || (val.respond_to?(:empty?) && val.empty?)
      end
      item_elems
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
