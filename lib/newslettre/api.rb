class Newslettre::API
  attr_accessor :email, :password, :format, :url

  def initialize options = {}
    @url = "https://sendgrid.com/api/newsletter"
    @email = options.delete :email
    @password = options.delete :password
    @format = :json
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

      response, status, body = request url_for(m, options), params

      raise ClientFailure, body if status > 399 and status < 500
      raise EndpointFailure, body if status > 499

      respond body
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

  def request address, params
    fields =  params.merge(credentials).map { |key, value|
      if value.kind_of? Array
        value.map {|v| Curl::PostField.content("#{key}[]", v.to_s) }
      else
        Curl::PostField.content(key.to_s, value.to_s)
      end
    }.flatten

    curl = Curl::Easy.new address

    curl.http_post(*fields)

    [curl, curl.response_code, curl.body_str]
  end

  def respond body
    JSON.load body
  end

  def url_for path, options = {}
    "#{url}#{options[:prefix]}/#{path}.#{format}"
  end
end
