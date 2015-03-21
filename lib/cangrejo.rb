require "cangrejo/version"
require "cangrejo/errors"
require "cangrejo/configurator"
require "cangrejo/session"

module Cangrejo

  @@config = OpenStruct.new({
    crabfarm_host: 'http://api.crabfarm.io',
    crawler_cache_path: 'tmp/crawler_cache',
    temp_path: 'tmp',
    crawlers: Hash.new
  })

  def self.config
    @@config
  end

  def self.configure
    yield Configurator.new @@config
  end

  def self.connect _name_or_config=nil, &_block
    _name_or_config = config[:crawlers].values.first if _name_or_config.nil?
    Session.connect _name_or_config, &_block
  end

end
