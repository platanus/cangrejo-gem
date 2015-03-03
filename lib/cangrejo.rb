require "cangrejo/version"
require "cangrejo/errors"
require "cangrejo/configurator"
require "cangrejo/session"

module Cangrejo

  @@config = OpenStruct.new({
    crabfarm_host: 'http://www.crabfarm.io',
    crawler_cache_path: 'tmp/crawler_cache',
    temp_path: 'tmp',
    hold_by_default: false,
    crawlers: Hash.new
  })

  def self.config
    @@config
  end

  def self.configure
    yield Configurator.new @@config
  end
end
