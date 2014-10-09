class Session
  # find the cookie for this app
  # deserialize the cookie into a hash
  def initialize(req)
    req.cookies.each do |cookie|
      if cookie.name == "_rails_lite_app"
        @cookie = cookie.value ? JSON.parse(cookie.value) : {}
      end
    end
    @cookie ||= {}
    @authentication_token = new_authentication_token
  end

  def [](key)
    @cookie[key]
  end

  def []=(key, val)
    @cookie[key] = val
  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_session(res)
    new_cookie = WEBrick::Cookie.new(
      "_rails_lite_app",
      @cookie.to_json
    )
    res.cookies << new_cookie
  end
  
  def new_authentication_token
    @authentication_token = 
  
  def form_authentication_token
    @authentication_token
  end
  
end