require 'httparty'

module Newslettre
  class Client
    include HTTParty
    attr_reader :email, :password, :url
    def initialize options = {}
      @url = "https://sendgrid.com/api/newsletter/"
      @email = options.delete :email
      @password = options.delete :password
    end



  end

  class Newsletter
    attr_reader :client


    def initialize client
      @client = client
    end

    def post name, identity, subject, data

    end
    alias_method :add, :post

    def list
      @client.get 

    end

    def get name
    end

    def delete name

    end

    def put name, newname, identity, subject, data

    end
    alias_method :edit, :put
  end
end
