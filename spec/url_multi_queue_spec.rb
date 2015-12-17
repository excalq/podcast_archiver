require 'rspec'
require_relative '../lib/podcast_archiver/_url_multi_queue'

describe PodcastArchiver::UrlMultiQueue do

  let(:queue_class) { PodcastArchiver::UrlMultiQueue }
  let(:max_concurrency) { 3 }

  it 'keeps a queue of urls' do
    umq = queue_class.new(max_concurrency)
    url = 'http://example.io/foo/'
    connection_id = queue_class::connection_id(url)

    umq.push("#{url}0")
    umq << "#{url}1"     # << is an alias to #push
    expect(umq.pop(connection_id)).to eq 'http://example.io/foo/0'
    expect(umq.pop(connection_id)).to eq 'http://example.io/foo/1'
  end

  it 'segregates queues by host+port' do
    umq = queue_class.new(max_concurrency)
    urlA = 'http://example.io/foo/'  # http
    urlB = 'https://example.io/foo/' # https
    connectionA_id = queue_class::connection_id(urlA)
    connectionB_id = queue_class::connection_id(urlB)

    2.times { |i| umq.push("#{urlA}#{i}") }
    2.times { |i| umq.push("#{urlB}#{i}") }
    expect(umq.pop(connectionA_id)).to eq 'http://example.io/foo/0'
    expect(umq.pop(connectionB_id)).to eq 'https://example.io/foo/0'
    expect(umq.pop(connectionA_id)).to eq 'http://example.io/foo/1'
  end

  it 'tracks max concurrency limits' do
    umq = queue_class.new(max_concurrency)
    umq.push('http://example.io/foo/1')
    umq.push('http://example.io/foo/2')
    umq.push('http://example.io/foo/3')
    expect(umq.max_exceeded?('http://example.io/foo/X')).to be false

    # Test HTTPS vs HTTP edge case
    umq.push('https://example.io/foo/1')
    expect(umq.max_exceeded?('http://example.io/foo/X')).to be false
    
    # Test HTTPS vs HTTP edge case
    umq.push('http://example.io/foo/4')
    umq.pop(queue_class::connection_id('https://example.io'))
    expect(umq.max_exceeded?('http://example.io/foo/X')).to be true

    expect(umq.max_exceeded?('http://another.com/foo/X')).to be false

    # One pop() should get us below "max_concurrency"
    umq.pop(queue_class::connection_id('http://example.io'))
    expect(umq.max_exceeded?('http://example.io/foo/X')).to be false
  end

  it 'provides host+port basename' do
    expect(queue_class::connection_id('http://example.com/foo/bar'))
        .to eq :examplecom80
    expect(queue_class::connection_id('https://example.io/foo/bar'))
        .to eq :exampleio443
    expect(queue_class::connection_id('file:///Users/me/example.io/foo/bar'))
        .to eq :local
  end

end