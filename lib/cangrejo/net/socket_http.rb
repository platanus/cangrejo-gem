require 'net/http'

module Net
  #  Overrides the connect method to simply connect to a unix domain socket.
  class SocketHttp < HTTP
    attr_reader :socket_path

    #  URI should be a relative URI giving the path on the HTTP server.
    #  socket_path is the filesystem path to the socket the server is listening to.
    def initialize(_socket_path, _dummy=nil)
      @socket_path = _socket_path
      super
    end

    #  Create the socket object.
    def connect
      @socket = Net::BufferedIO.new UNIXSocket.new socket_path
      on_connect
    end

    #  Override to prevent errors concatenating relative URI objects.
    def addr_port
      File.basename(socket_path)
    end
  end
end
