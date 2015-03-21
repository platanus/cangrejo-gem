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

```ruby
Cangrejo.configure do |config|
  config.set_crawler_cache_path 'tmp' # make sure this path exists!
  config.set_temp_path '/tmp/crawler_cache' # make sure this path exists!

  if Rails.env.development?
    # Override crawler configurations, more on this later
    config.set_crawler_setup_for 'platanus/some-crawler', {
      path: '/path/to/crawler',
      git_remote: 'git://crawler/repo',
      git_commit: 'ThEcr4wl3rc0m1ty0un33d'
    }
  end
end
```

#### Rails integration

When using cangrejo inside a rails app use the following base configuration inside an initializer (railtie is comming soon!):

```ruby
Cangrejo.configure do |config|
  config.set_temp_path Rails.root.join '/tmp'
end
```

#### About crawler configurations

There are three ways to run a crawler:

By default, crawlers are identified by their unique uri (like `platanus/demo`)and ran in the **Crabfarm.io cloud**. To do so you will need to create an account and register the crawler repo.

Crawlers can also be run from a local repository, just map the crawler uri to a path in the initializer:

```ruby
config.set_crawler_setup_for 'org/repo', {
  path: '/path/to/crawler'
}
```

Crawlers can also be ran from a git remote, the crawler is downloaded to the path specified using `config.set_crawler_cache_path` and then ran locally:

```ruby
config.set_crawler_setup_for 'org/repo', {
  git_remote: 'git://crawler/repo',
  git_commit: 'ThEcr4wl3rc0m1ty0un33d'
}
```

### Sessions

To communicate with crawlers you use crawling sessions. event though you can manually build and start a session, it is recommended to use the `Cangrejo.connect` method to handle session lifecycle for you:

```ruby
Cangrejo.connect 'org/repo' do |session|
  session.crawl(:front_page, param1: 'hello')
end
```

You can also call connect **with no crawler name**, if so, connect will use the crawler that was registered first in the configuration.

Once inside a connect block, you can change the session state using `crawl`

```ruby
session.crawl(:front_page, param1: 'hello')
```

Data extracted by last crawl is available at `doc` property as an open struct

```ruby
session.doc.title
session.doc.price
```

You can also create, start and stop sessions manually;

```ruby
session = Cangrejo::Session.new 'org/repo'
session.crawl(:front_page, param1: 'hello')
session.relase
```

Don't forget to release the session when you are done!! Once released the session becomes unusable.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/cangrejo/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
