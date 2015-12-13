require 'spec_helper'

describe PodcastArchiver do

  OUTDIR = File.expand_path(File.dirname(__FILE__))
  RES_DIR = File.join OUTDIR, "resources"
  TEST_MEDIA = File.join RES_DIR, "empty.ogg"

  let(:sample_rss) { generate_rss(TEST_MEDIA) }
  after (:all) { clean_resources }


  it 'has a version number' do
    expect(PodcastArchiver::VERSION).not_to be nil
  end

  it 'has a load method which returns a worker object' do
    opts = {quiet: true}
    expect(PodcastArchiver.load(sample_rss, OUTDIR, opts)).to be_instance_of(PodcastArchiver::BackgroundWorker)
    clean_resources
  end

  it 'shows an error if an invalid dir is given' do
    expect{ PodcastArchiver.load(sample_rss, '/not/a/real/path') }.to raise_error(Errno::ENOENT)
  end


  ### Helping functions

  def generate_rss(filepath)
    template = File.read(File.join(File.dirname(filepath), "sample.hbs.rss")) # auto closes in Ruby 1.9+
    generated_rss = File.join(RES_DIR, 'sample.rss')
    File.open(generated_rss, 'w') { |f| f.write template.gsub('{{URL-GOES-HERE}}', filepath) }
    generated_rss
  end

  def clean_resources
    generated_rss = File.join(RES_DIR, 'sample.rss')
    File.unlink(generated_rss) if File.exists? generated_rss
  end

end


