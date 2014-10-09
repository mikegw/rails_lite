class Flash

  attr_accessor :messages, :message_life

  def initialize
    @messages = {}
    @message_life = 1
  end

  def clear_dead
    messages.select! {|msg,life| life > 0}
    messages.each_pair {|msg, life| life -= 1}
  end

  def now
    message_life = 0
    return self
  end

  def []=(key, content)
    messages[key] = {content: content, life: message_life}

  def [](key)
    messages[key][:content]
  end

end