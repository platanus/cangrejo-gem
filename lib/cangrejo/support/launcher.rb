module Cangrejo
  module Support
    class Launcher

      def initialize(_path)
        @path = _path
        select_socket_file
      end

      def host
        "unix://#{@socket_file}"
      end

      def launch
        gem_path = File.join(@path, 'Gemfile')
        # TODO: for some reason, the gemfile path must be specified here, maybe because of rbenv?
        @pid = Process.spawn({ 'BUNDLE_GEMFILE' => gem_path }, "bin/crabfarm s --host #{host}", chdir: @path)
        wait_for_socket
      end

      def kill
        unless @pid.nil?
          Process.kill 'INT', @pid
          Process.wait @pid
        end
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
    end
  end
end