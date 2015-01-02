module Cangrejo
  class Configurator

    [
      :crabfarm_host,
      :crawler_cache_path,
      :temp_path,
      :hold_by_default
    ]
    .each do |name|
      define_method "set_#{name}" do |value|
        @config.send("#{name}=", value)
      end
    end

    def initialize(_config)
      @config = _config
    end

    def crawler(_name, _options)
      @config.crawlers[_name] = _options
    end

  end

end
