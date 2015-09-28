module Cangrejo

	class Error < StandardError; end

  class ConfigurationError < Error; end

  class LaunchTimeout < Error
    def initialize(_msg)
      super "Timed out trying to start crawler"
    end
  end

  class CrawlerError < Error

    def initialize(_msg, _backtrace)
      super _msg
      @original_bt = _backtrace
    end

    def set_backtrace(_backtrace)
      super @original_bt + _backtrace
    end

  end

end