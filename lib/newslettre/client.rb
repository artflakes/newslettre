class Newslettre::Client
  include HTTParty
  format :json
  attr_reader :email, :password, :format


  def initialize options = {}
    self.class.base_uri "https://sendgrid.com/api/newsletter"
    @email = options.delete :email
    @password = options.delete :password
    @format = "json"
  end


  def url
    @url ||= self.class.default_options[:base_uri]
  end

  %w{get list add delete edit}.each do |m|
    define_method m do |*args|
      params, options = args
      params ||= {}
      options ||= {}
      response = self.class.post url_for(m, options), :query => params.merge(credentials)
      raise ClientFailure if response.code > 399 and response.code < 500
      raise EndpointFailure if response.code > 499
      response
    end
  end

  alias_method :post, :add
  alias_method :put, :edit

  class ClientFailure < StandardError; end
  class EndpointFailure < StandardError; end

  protected

  def credentials
    {
      :api_user => email,
      :api_key => password
    }
  end

  def url_for path, options = {}
    "#{options[:prefix]}/#{path}.#{format}"
  end
end
