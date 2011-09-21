class Newslettre::Client
  attr_reader :api
  def initialize email, password
    @api = Newslettre::API.new :email => email, :password => password
  end

  def newsletters
    @newsletters ||= proxy_for Newslettre::Letter
  end

  def identities
    @identities ||= proxy_for Newslettre::Identity
  end

  def lists
    @lists ||= proxy_for Newslettre::Lists
  end

  protected

  def proxy_for klass
    Newslettre::APIModuleProxy.new self, klass.new(@api)
  end
end
