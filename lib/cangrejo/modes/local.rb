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

        @process = prepare_process
        start_process @process

        wait_for_socket
        init_rest_client
      end

      def release
        stop_process(@process) unless @process.nil?
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

      def prepare_process
        cmd = [ "bin/crabfarm", "s", "--host=#{host}" ]
        cmd += cmd_arguments

        cp = ChildProcess.build(*cmd)
        cp.environment.merge! cmd_enviroment
        cp.cwd = @path
        cp.leader = true
        cp.io.inherit!

        return cp
      end

      def start_process(_process)
        _process.start
      end

      def stop_process(_process)
        _process.stop
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
        # TODO: add posibility to use ports instead of unix sockets, it would also
        # be nice to have a mechanism where the loaded process reports the port it
        # binded to.
        "unix://#{@socket_file}"
      end

    end
  end
end