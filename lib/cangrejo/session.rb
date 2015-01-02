require "ostruct"
require "cangrejo/modes/remote"
require "cangrejo/modes/git"
require "cangrejo/modes/local"

module Cangrejo
  class Session
    include Forwardable

    attr_reader :doc

    def initialize(_name, _options={})
      @name = _name
      options = Cangrejo.config.crawlers.fetch(_name, {}).merge _options
      select_mode options
      start unless _options.fetch :hold, Cangrejo.config.hold_by_default
    end

    def start
      raise ConfigurationError.new 'Session already started' unless @rest.nil?
      @rest = @mode.setup
      self
    end

    def state_name
      @rest.name
    end

    def state_params
      @rest.params
    end

    def raw_doc
      @rest.doc
    end

    def crawl(_state, _params={})
      raise ConfigurationError.new 'Session not started' if @rest.nil?
      @rest.put(name: _state, params: _params)
      @doc = OpenStruct.new @rest.doc
      self
    end

    def release
      @mode.release
      self
    end

  private

    def select_mode(_options)
      @mode = if _options.has_key? :path
        Modes::Local.new _options[:path]
      elsif _options.has_key? :git_remote
        Modes::Git.new _options[:git_remote], _options[:git_commit], _options[:relative_path], @name
      else
        Modes::Remote.new @name
      end
    end

  end
end
