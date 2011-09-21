class Newslettre::API
  include HTTParty
  format :json
  attr_accessor :email, :password

  base_uri "https://sendgrid.com/api/newsletter"

  def initialize options = {}
    @email = options.delete :email
    @password = options.delete :password
  end

  def url
    @url ||= self.class.default_options[:base_uri]
  end

  def format
    @format ||= self.class.default_options[:format]
  end

  def authenticated?
    not email.nil? and not password.nil?
  end

  %w{get list add delete edit}.each do |m|
    define_method m do |*args|
      raise NotAuthenticatedFailure unless authenticated?
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

  class NotAuthenticatedFailure < StandardError; end
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
