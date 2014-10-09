module URLHelper

  def create_url(method, *args)
    method_arr = method.to_s.split("_")
    url = ""
    action = ( ["new", "edit"].include?(method_arr.first) ? method_arr.shift : nil )

    method_arr[0...-1].each do |model|
      url += "/#{model}"
      url += "/#{args.shift}" unless model[-1] == "s"
    end

    url += "/new" if action == "new"
    /\/\//.match(url) ? url : raise InvalidArgumentError
  end

  def method_missing(method, *args, &blk)
    if /_url$/.match(method)
      create_url(method, *args)
    else
      super(method, *args, &blk)
    end
  end

end


