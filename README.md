# PodcastArchiver

**[NOTE: This is a work under active development. A usable version should be available be 
20 December 2015!]**

A simple tool to archive or mirror an audio or video RSS podcast.

This tool enables cloning of a given RSS or podcast feed, downloading selected (or all) media files locally, as well as 
generating a new RSS file with links to the downloaded media. Media files can have their id metadata tags set using 
metadata from the original RSS.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'podcast_archiver'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install podcast_archiver

## Usage

This can be used in two ways: either invoked via the command line (not Rake or IRB), or as a
gem embedded within a larger project.

To invoke via CLI: Run `bin/podcast_archiver RSS_URL [options]`

Run `bin/podcast_archiver --help` for detailed options.

To invoke in a project, interface with the `PodcastArchiver` module. The `load()` method returns
a `PodcastArchiver::BackgroundWorker` instance.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/podcast_archiver/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
