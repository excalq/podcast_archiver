require 'spec_helper'
require_relative '../lib/podcast_archiver/file_retriever'

describe PodcastArchiver::FileRetriever do

  let(:max_concurrency) { 3 }
  let(:fret) { PodcastArchiver::FileRetriever.new(max_concurrency) }
  let(:queue_class) { PodcastArchiver::UrlMultiQueue }

  it 'queues urls for download' do
    max_concurrency = 0
    url = 'http://example.com/foo/bar.xyz'
    fret.download(url, OUT_DIR)
    fret.download(url, OUT_DIR)
    queue = fret.instance_variable_get(:@download_queue)
    queued = queue.num_queued(queue_class::connection_id(url))
    expect(queued).to eq 2
  end

  it 'downloads urls simultaneously' do end

  it 'handles local file urls' do end

  it 'correctly writes local files' do end

  it 'handles permission issues' do end

end