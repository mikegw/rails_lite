require 'uri'

module Phase5
  class Params
    # use your initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params

    attr_reader :route_params

    def initialize(req, route_params = {})
      @route_params = route_params
      parse_www_encoded_form(req.query_string) if req.query_string
      parse_www_encoded_form(req.body) if req.body
      p ["in params", route_params]
    end

    def [](key)
      @route_params[key.to_s]
    end

    def to_s
      @route_params.to_json.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    private
    # this should return deeply nested hash
    # argument format
    # user[address][street]=main&user[address][zip]=89436
    # should return
    # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
    def parse_www_encoded_form(www_encoded_form)
      pairs = URI.decode_www_form(www_encoded_form)
      pairs.each do |k,v|
        unstacked = parse_key(k)
        if unstacked.length > 2
          partial_hash = {unstacked[-1] => v}
          (unstacked.length - 2).downto(1) do |i|
            partial_hash = {unstacked[i] => partial_hash}
          end
          @route_params[unstacked[0]] = partial_hash
        else
          @route_params[unstacked[0]] = v
        end
      end


    end

    # this should return an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
      key.split(/\]\[|\[|\]/)
    end
  end
end

# THIS IS AWESOME but not useful here... :(
class Hash
  def self.recursive
    new { |k,v| k[v] = recursive }
  end
  #a[b][c][d] = e => {b => {c => {d => e}}
end
