require_relative '../phase5/controller_base'
require_relative '../phase5/params'

module Phase6
  class ControllerBase < Phase5::ControllerBase

    attr_reader :params

    def initialize(req, res, route_params = {})
      super(req, res)
      @params = Phase5::Params.new(req, route_params)
    end


    # use this with the router to call action_name (:index, :show, :create...)
    def invoke_action(name)
      self.send(name)
    end
  end
end
