require "cangrejo/restclient/json_resource"

module Cangrejo
  module Modes
    class Remote

      def initialize(_name)
        @name = _name
      end

      def setup
        sessions = prepare_resource "api/crawlers/#{@name}/sessions"
        sessions.post({}.to_json)
        return prepare_resource "api/sessions/#{sessions.id}"
      end

      def release
        # nothing
      end

    private

      def prepare_resource(_path)
        RestClient::JsonResource.new URI.join(remote_host, _path).to_s
      end

      def remote_host
        Cangrejo.config.crabfarm_host
      end

    end
  end
end