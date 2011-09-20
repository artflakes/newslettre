class Newslettre::APIModule
  attr_reader :client

  def initialize client
    @client = client
  end

  protected

  def api_prefix
    "/#{self.class.name.split(/::/).last.downcase}"
  end

  def request method, data = {}
    self.client.send method, data, { :prefix => api_prefix }
  end
end
