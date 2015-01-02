require "cangrejo/net/socket_http"
require "cangrejo/net/socket_uri"
require "rest_client"

module RestClient
  module RequestExtensions

    def process_url_params(_url, _headers)
      if _url.is_a? String then super(_url, _headers) else _url end
    end

    def parse_url(_url)
      if _url.is_a? String then super(_url) else _url end
    end

    def net_http_class
      if url.is_a? Net::SocketUri then
        Net::SocketHttp
      else super end
    end

  end

  class Request
    prepend RequestExtensions
  end
end
