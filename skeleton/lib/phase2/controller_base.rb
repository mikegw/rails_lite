module Phase2
  class ControllerBase
    attr_reader :req, :res

    # Setup the controller
    def initialize(req, res)
      @req = req
      @res = res
      @already_built_response = false
    end

    # Helper method to alias @already_built_res
    def already_built_response?
      @already_built_response
    end

    # Set the res status code and header
    def redirect_to(url)
      raise "Already built a res!" if already_built_response?
      res.status = 302
      res.header["status"] = "Found"
      res.header["location"] = url
      @already_built_response = true
    end

    # Populate the res with content.
    # Set the res's content type to the given type.
    # Raise an error if the developer tries to double render.
    def render_content(content, type)
      raise "Already built a response!" if already_built_response?
      res.content_type = type
      res.body = content
      @already_built_response = true
    end
  end
end
