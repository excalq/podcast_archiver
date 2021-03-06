require_relative 'podcast_archiver/file_retriever'
require_relative 'podcast_archiver/id_tag_writer'
require_relative 'podcast_archiver/rss_handler'
require_relative 'podcast_archiver/version'

require 'awesome_print' # DEV DEBUGGING ONLY

# Project TODO:
# 1. Provide ATOM support
# 2. Support ATOM pagination
# 3. Provide logging support (using logger passed to gem)
#

module PodcastArchiver
  OptionsStruct = Struct.new(
      :output_dir, # download media to here
      :limit, # How many episodes to fetch
      :offset, # Skip this many before starting
      :nice, # Downloads slowly (rate defined in constant)
      :baseurl, # Edit media urls in new RSS to this prefix (e.g. http://mirror.mycast.com/a/path/)
      :quiet, # Prints only errors
      :dry_run # Only reads RSS, then prints titles and new URLs
  )

  def self.load(url, outdir, options={})
    BackgroundWorker.new(url, outdir, options)
  end

  class BackgroundWorker

    @input_rss  # <RssHandler>
    @output_dir # <Dir>
    @options # instance of Options struct

    def initialize(url, outdir, options={})
      raise ArgumentError, "url and output dir must be given." if (url.nil? || outdir.nil?)
      puts "WARNING: Directory #{outdir} is not empty!." unless Dir.glob("#{outdir}/{*,.*}").empty?

      @input_rss = RssHandler.new(url, options)
      Dir.mkdir(outdir, 0600) unless Dir.exists?(outdir)
      @output_dir = Dir.new(outdir)
      @options = OptionsStruct.new(*options.values_at(*OptionsStruct.members))

      puts "Running with options: #{options.inspect}" unless @options.quiet
    end

    def run

    end

    def get_status

    end

    def get_percent_done

    end

  end

end
