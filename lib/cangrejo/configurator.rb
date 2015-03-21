module Cangrejo
  class Configurator

    [
      :crabfarm_host,
      :crawler_cache_path,
      :temp_path
    ]
    .each do |name|
      define_method "set_#{name}" do |value|
        @config.send("#{name}=", value)
      end
    end

    def initialize(_config)
      @config = _config
    end

    def set_crawler_setup(_options)
      @config.crawlers[nil] = _options
    end

    def set_crawler_setup_for(_name, _options)
      @config.crawlers[_name] = _options
    end

  end

end
