require_relative '../phase2/controller_base'
require 'active_support/core_ext'
require 'erb'

module Phase3
  class ControllerBase < Phase2::ControllerBase
    # use ERB and binding to evaluate templates
    # pass the rendered html to render_content
    def render(template_name)
      template = File.readlines("views/#{self.class.name.underscore}/#{template_name}.html.erb")
      render_content(ERB.new("<%= template %>").result(binding), "text/html")
    end
  end
end
