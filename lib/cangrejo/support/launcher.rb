require 'timeout'

module Cangrejo
  module Support
    class Launcher

      class LaunchTimeout < Cangrejo::Error
        def initialize(_msg)
          super "Timed out trying to start crawler"
        end
      end

      SPAWN_TIMEOUT = 5
      KILL_TIMEOUT = 5

      def initialize(_path, _options=nil)
        @path = _path
        @options = _options || []
        select_socket_file
      end

      def host
        "unix://#{@socket_file}"
      end

      def launch
        gem_path = File.join(@path, 'Gemfile')
        # TODO: for some reason, the gemfile path must be specified here, maybe because of rbenv?
        @pid = Process.spawn({ 'BUNDLE_GEMFILE' => gem_path }, "bin/crabfarm s --host=#{host} #{@options.join(' ')}", chdir: @path, pgroup: true)
        wait_for_socket
      end

      def kill
        safe_kill @pid unless @pid.nil?
      end

    private

      def select_socket_file
        @socket_file = random_filename while @socket_file.nil? or File.exist? @socket_file
      end

      def random_filename
        File.join(Cangrejo.config.temp_path, "csocket-#{Random.rand(1000000)}.sock")
      end

      def wait_for_socket
        Timeout::timeout(SPAWN_TIMEOUT, LaunchTimeout) do
          # TODO: detect if the process crashes before timeout
          sleep 0.1 while not File.exist? @socket_file
        end
      end

      def safe_kill _pid
        begin
          Timeout.timeout(KILL_TIMEOUT) do
            Process.kill "INT", _pid
            Process.wait _pid
          end
        rescue Timeout::Error
        ensure
          # Kill the entire process group to make sure childs aren't left hanging around
          Process.kill -9, _pid
          Process.wait _pid
        end
      end

    end
  end
end