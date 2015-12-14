$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'podcast_archiver'

THIS_DIR = File.expand_path(File.dirname(__FILE__))
OUT_DIR =  File.join THIS_DIR, "out"
RES_DIR = File.join THIS_DIR, "resources"
TEST_MEDIA = File.join RES_DIR, "empty.ogg"

### Helping functions

def generate_rss(media_file)
  template = File.read(File.join(RES_DIR, "sample.hbs.rss")) # auto closes in Ruby 1.9+
  generated_rss = File.join(RES_DIR, 'sample.rss')
  File.open(generated_rss, 'w') { |f| f.write template.gsub('{{URL-GOES-HERE}}', media_file) }
  generated_rss
end

def clean_resources
  generated_rss = File.join(RES_DIR, 'sample.rss')
  Dir.unlink(OUT_DIR)
  File.unlink(generated_rss) if File.exists? generated_rss
end