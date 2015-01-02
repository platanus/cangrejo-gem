# Cangrejo

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'cangrejo'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cangrejo

## Usage

### Configuration

Create an initializer an call `Cangrejo.config`

```ruby
Cangrejo.config do |config|
  set_username = ""
  set_password = ""
  set_crawler_cache_path '/tmp/crawler_cache'

  if Rails.env.development?
    # Override crawler configurations
    crawler 'some_crawler', {
      path: '/path/to/crawler',
      git_remote: 'git://crawler/repo',
      git_commit: 'ThEcr4wl3rc0m1ty0un33d'
    }
  end
end
```

### Sessions

Then load a crawler session, set `hold: true` to start it manually. Same options available in config are available during initialization.

```ruby
session = Cangrejo::Session.new 'some_crawler', hold: true
```

Start it to deploy and start the crawler.

```ruby
session.start
```

Change its state to crawl

```ruby
session.crawl(:front_page, param1: 'hello')
```

Data extracted by last crawl is available at `doc` property as an open struct

```ruby
session.doc.title
session.doc.price
```

Don't forget to release the session when you are done!! Once released the session becomes unusable.

```ruby
session.release
```

TODO: Write usage instructions here

## Contributing

1. Fork it ( https://github.com/[my-github-username]/cangrejo/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
