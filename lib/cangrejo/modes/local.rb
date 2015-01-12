require "cangrejo/restclient/request_extensions"
require "cangrejo/restclient/json_resource"
require "cangrejo/support/launcher"

module Cangrejo
  module Modes
    class Local

      def initialize(_path)
        @path = _path
      end

      def setup
        init_launcher
        init_rest_client
      end

      def release
        @launcher.kill unless @launcher.nil?
      end

    private

      def init_launcher
        @launcher = Support::Launcher.new @path
        @launcher.launch
      end

      def init_rest_client
        RestClient::JsonResource.new Net::SocketUri.new(@launcher.host, '/api/state')
      end

    end
  end
end