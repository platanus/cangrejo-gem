module Net
  class SocketUri

    def initialize(_socket_path, _path)
      @socket_path = _socket_path[7..-1]
      @path = _path
    end

    def hostname
      @socket_path
    end

    def host
      @socket_path
    end

    def request_uri
      @path
    end

    def empty?
      false
    end

    def port
      nil
    end

    def path
      @path
    end

    def user
      nil
    end

    def password
      nil
    end

    def to_s
      "#{@socket_path}::@path"
    end

  end
end
