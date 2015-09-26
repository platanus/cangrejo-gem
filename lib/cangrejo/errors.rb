module Cangrejo

	class Error < StandardError; end

  class ConfigurationError < Error; end

  class LaunchTimeout < Error
    def initialize(_msg)
      super "Timed out trying to start crawler"
    end
  end

end