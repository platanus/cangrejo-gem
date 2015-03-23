require "rest_client"

module RestClient

  class JsonResource < Resource

    def get(additional_headers={}, &block)
      additional_headers['Accept'] = 'json'
      r = super additional_headers, &block
      @state = JSON.parse r
      self
    end

    def post(payload, additional_headers={}, &block)
      r = super payload.to_json, decorate_headers(additional_headers), &block
      @state = JSON.parse r
      self
    end

    def put(payload, additional_headers={}, &block)
      r = super payload.to_json, decorate_headers(additional_headers), &block
      @state = JSON.parse r
      self
    end

    def delete(additional_headers={}, &block)
      super decorate_headers(additional_headers), &block
      self
    end

  private

    def decorate_headers(_headers)
      _headers['Content-Type'] = 'application/json'
      _headers
    end

    def method_missing(_method, *_args, &_block)
      if @state.is_a? Hash and @state.has_key? _method.to_s
        @state[_method.to_s]
      else super end
    end

  end

end
