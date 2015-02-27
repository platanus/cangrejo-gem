require 'timeout'

module Cangrejo
  module Support
    class Launcher

      KILL_TIMEOUT = 5.0

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
        @pid = Process.spawn({ 'BUNDLE_GEMFILE' => gem_path }, "bin/crabfarm s --host=#{host} #{@options.join(' ')}", chdir: @path)
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
        sleep 0.1 while not File.exist? @socket_file
      end

      def safe_kill _pid
        begin
          Timeout.timeout(KILL_TIMEOUT) do
            Process.kill 'INT', _pid
            Process.wait _pid
          end
        rescue Timeout::Error
          Process.kill 9, _pid
          Process.wait _pid # prevent zombies!
        end
      end

    end
  end
end