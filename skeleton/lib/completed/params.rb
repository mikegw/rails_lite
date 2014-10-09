class Params

  attr_reader :route_params

  def initialize(req, route_params = {})
    @route_params = Hash.recursive.merge(route_params)
    #parse_www_encoded_form(req.query_string) if req.query_string
    #parse_www_encoded_form(req.body) if req.body
  end

  def [](key)
    @route_params[key.to_s]
  end

  def to_s
    @route_params.to_json.to_s
  end

  def awesomely_parse(www_form)
    instructions = www_form.split("&")
    instructions.each{|str| eval_instruction(str)}
  end

  def eval_instruction(instruction_str)
    # turn eg. user[address][street] = "stuff"
    # into route_params[:user][:address][:street] = "stuff"
    instruction_str.gsub!(/(\w+)/, '"\1"')
    instruction_arr = /(?<first_word>\"\w+\")(?<rest>.+)/.match(instruction_str)

    instruction =
      "route_params" +
      "[:#{instruction_arr[:first_word]}]" +
      instruction_arr[:rest]

    self.instance_eval(instruction)
  end

end

# THIS IS AWESOME :) (credit to molf of stackoverflow)
class Hash
  def self.recursive
    new { |k,v| k[v] = recursive }
  end
  # a[b][c][d] = e  #=> {b => {c => {d => e}}
end