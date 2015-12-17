$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'podcast_archiver'

THIS_DIR = File.expand_path(File.dirname(__FILE__))
OUT_DIR =  File.join THIS_DIR, "out"
RES_DIR = File.join THIS_DIR, "resources"
TEST_MEDIA = File.join RES_DIR, "empty.ogg"

### Helping functions

def clean_generated_files
  Dir.unlink(OUT_DIR)
end