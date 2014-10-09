require 'active_support/core_ext'
require 'erb'
require_relative './session'
require 'json'
require 'webrick'

class ControllerBase

  attr_reader :req, :res, :params

  # setup the controller
  def initialize(req, res, route_params = {})
    @params = Phase5::Params.new(req, route_params)
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

    session.store_session(res)
    @already_built_response = true
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    template = File.readlines("views/#{self.class.name.underscore}/#{template_name}.html.erb")
    render_content(ERB.new("<%= template %>").result(binding), "text/html")
  end

  # Populate the res with content.
  # Set the res's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, type)
    raise "Already built a response!" if already_built_response?
    res.content_type = type
    res.body = content

    session.store_session(res)
    @already_built_response = true
  end

  def session
    @session ||= Session.new(req)
  end

  def invoke_action(name)
    self.send(name)
  end

end