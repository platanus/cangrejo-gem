require "ostruct"

module Cangrejo
  class Session

    WAIT_STEP = 45.0 # Ruby sockets automatically timeout after 60 secs

    attr_reader :doc, :state_name, :state_params

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

    def elapsed
      @rest.elapsed
    end

    def raw_doc
      @rest.doc
    end

    def crawl(_state, _params={})
      raise ConfigurationError.new 'Session not started' if @rest.nil?

      params = add_timestamp(_params)

      while_times_out do
        @rest.put(name: _state, params: params, wait: WAIT_STEP)
        @state_name = _state
        @state_params = _params
      end

      wrap_response_doc
      self
    end

    def release
      @mode.release
      self
    end

  private

    def add_timestamp(_params)
      _params.merge({
        '_ts' => DateTime.now.strftime('%Q')
      })
    end

    def while_times_out
      loop do
        begin
          yield
          break
        rescue RestClient::RequestTimeout
          # retry on timeout
        end
      end
    end

    def wrap_response_doc
      @doc = OpenStruct.new @rest.doc
    end

    def select_mode(_options)
      @mode = if _options.has_key? :mode
        _options[:mode]
      elsif _options.has_key? :path
        require "cangrejo/modes/local"
        Modes::Local.new _options[:path]
      elsif _options.has_key? :git_remote
        require "cangrejo/modes/git"
        Modes::Git.new _options[:git_remote], _options[:git_commit], _options[:relative_path], @name
      else
        require "cangrejo/modes/remote"
        Modes::Remote.new @name
      end
    end

  end
end
