class Newslettre::APIModule
  attr_reader :api

  def initialize api
    @api = api
  end

  protected

  def api_prefix
    "/#{self.class.name.split(/::/).last.downcase}"
  end

  def request method, data = {}
    @api.send method, data, { :prefix => api_prefix }
  end
end
