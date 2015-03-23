require "cangrejo/restclient/json_resource"

module Cangrejo
  module Modes
    class Remote

      def initialize(_remote)
        @remote = _remote
      end

      def setup
        @session = create_session
      end

      def release
        @session.put({ status: 'finished' }) unless @session.nil?
        @session = nil
      end

    private

      def session_collection
        @collection ||= prepare_resource "api/bots/#{@remote}/sessions"
      end

      def create_session
        new_session_id = session_collection.post({}.to_json).id
        prepare_resource "api/sessions/#{new_session_id}"
      end

      def prepare_resource(_path)
        RestClient::JsonResource.new URI.join(remote_host, _path).to_s
      end

      def remote_host
        Cangrejo.config.crabfarm_host
      end

    end
  end
end