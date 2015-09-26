require "cangrejo/restclient/request_extensions"
require "cangrejo/restclient/json_resource"
require "childprocess"

module Cangrejo
  module Modes
    class Local

      attr_reader :process, :path

      def initialize(_path)
        @path = _path
      end

      def setup
        select_socket_file
        start_process
        wait_for_socket
        init_rest_client
      end

      def release
        process.stop unless process.nil?
      end

    private

      def cmd_enviroment
        {
          'BUNDLE_GEMFILE' => gem_path
        }
      end

      def cmd_arguments
        [
          '--no-reload'
        ]
      end

      def launch_timeout
        5.0
      end

      def start_process
        @process = prepare_process
        @process.start
      end

      def prepare_process
        cmd = [ "bin/crabfarm", "s", "--host=#{host}" ]
        cmd += cmd_arguments

        puts cmd.join(' ')

        cp = ChildProcess.build(*cmd)
        cp.environment.merge! cmd_enviroment
        cp.cwd = @path
        cp.leader = true
        cp.io.inherit!

        return cp
      end

      def wait_for_socket
        Timeout::timeout(launch_timeout, LaunchTimeout) do
          # TODO: detect if the process crashes before timeout
          sleep 0.1 while not File.exist? @socket_file
        end
      end

      def init_rest_client
        RestClient::JsonResource.new Net::SocketUri.new(host, '/api/state')
      end

      def select_socket_file
        @socket_file = random_filename while @socket_file.nil? or File.exist? @socket_file
      end

      def random_filename
        File.join(Cangrejo.config.temp_path, "csocket-#{Random.rand(1000000)}.sock")
      end

      def gem_path
        File.join(@path, 'Gemfile')
      end

      def host
        "unix://#{@socket_file}"
      end

    end
  end
end