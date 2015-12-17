require 'spec_helper'
require_relative '../lib/podcast_archiver'

describe PodcastArchiver do

  # Constants are defined in spec helper

  let(:sample_rss)  { File.join(RES_DIR, "sample.rss") }
  let(:sample_atom) { File.join(RES_DIR, "sample.atom.rss") }
  after (:all) { clean_generated_files }

  it 'has a version number' do
    expect(PodcastArchiver::VERSION).not_to be nil
  end

  it 'has a load method which returns a worker object' do
    opts = {quiet: true}
    expect(PodcastArchiver.load(sample_rss, OUT_DIR, opts)).to be_instance_of(PodcastArchiver::BackgroundWorker)
  end

  it 'shows an error if an invalid dir is given' do
    expect{ PodcastArchiver.load(sample_rss, '/not/a/real/path') }.to raise_error(SystemCallError)
  end

  it 'downloads media files contained in the feed' do
    opts = {quiet: true}
    PodcastArchiver.load(sample_rss, OUT_DIR, opts)
    RssHandler.any_instance.stub_chain()

    local_files = Dir.glob "#{OUT_DIR}/*.ogg"
    expect(local_files).to eq ['empty.ogg']
  end

  it 'saves a local version of the RSS' do
    rss_media_links = ''
    feed_name = ''
    output_rss = "#{OUT_DIR}/#{feed_name}.rss"

    expect(rss_media_links).to eq ["file://#{OUT_DIR}/empty.ogg"]
  end

  it 'tags media files using supplied RSS' do
    pending 'TODO'
    fail
  end

end