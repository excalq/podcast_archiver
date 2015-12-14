require 'spec_helper'
require_relative '../lib/podcast_archiver/rss_handler'

describe PodcastArchiver::RssHandler do

  it 'takes options' do
    url = generate_rss(TEST_MEDIA)
    opts = {limit: 10, offset: 30, quiet: true}
    rss_parser = PodcastArchiver::RssHandler.new(url, opts)
    expect(rss_parser.instance_eval('@options').to_h).to include(opts)
  end

  it 'parses feed metadata' do
    url = generate_rss(TEST_MEDIA)
    rss_parser = PodcastArchiver::RssHandler.new(url)
    rss_contents = rss_parser.get_contents

    expect(rss_contents[:title]).to eq 'W3Schools Home Page'
    expect(rss_contents[:link]).to eq 'http://www.w3schools.com'
    expect(rss_contents[:description]).to eq 'Free web building tutorials'
    expect(rss_contents[:items].size).to be 2
    expect(rss_contents[:items][0][:title]).to eq 'RSS Tutorial'
    expect(rss_contents[:items][1][:title]).to eq 'JSON Tutorial'
    expect(rss_contents[:items][0][:link]).to eq '/Users/arthur/Hacking/Ruby/podcast_archiver/spec/resources/empty.ogg'
    expect(rss_contents[:items][0][:description]).to eq 'New RSS tutorial on W3Schools'
  end

  it 'supplies an enumerable #each method' do
    url = generate_rss(TEST_MEDIA)
    rss_parser = PodcastArchiver::RssHandler.new(url)
    items = []
    # note that #map uses #each internally
    rss_parser.map { |i| items << i.title }
    expect(items).to eq ['RSS Tutorial', 'JSON Tutorial']
  end

end