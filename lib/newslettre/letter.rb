class Newslettre::Letter < Newslettre::APIModule
  class Object < Struct.new(:owner, :name, :data)
    extend Forwardable

    def_delegator :owner, :request
    def_delegator :owner, :api

    def == other
      self.to_hash == other
    end

    def load_data
      self.data ||= request('get', :name => self.name).to_hash
    end

    def to_hash
      load_data

      data
    end

    def schedule
      scheduler.get
    end

    def deschedule!
      scheduler.delete
    end

    def schedule! options = {}
      scheduler.deliver options
    end

    def scheduled?
      begin
        !!schedule
      rescue NotScheduledFailure
        false
      end
    end

    def recipients
      @recipients ||= Newslettre::APIModuleProxy.new self, Recipients.new(self.name, self.api)
    end

    protected

    def scheduler
      @scheduler ||= Schedule.new self.name, self.api
    end
  end

  def list
    request('list').map do |n|
      Object.new self, n["name"]
    end
  end

  def add name, data = {}
    request 'add', data.merge(:name => name)
  end

  def get name
    Object.new self, name
  end

  def delete name
    request 'delete', :name => name
  end

  def edit name, data = {}
    request 'edit', data
  end

  class Schedule < Newslettre::APIModule
    attr_reader :letter

    def initialize letter, api
      @letter = letter
      @api = api
    end

    def deliver options = {}
      require 'time'
      data = { :name => letter }
      at = options.delete :at
      unless at.nil?
        data[:at] = at.iso8601
      end
      request :add, data
    end

    def delete
      request :delete, :name => letter

      true
    end

    def get
      require 'time'
      begin
        date = request(:get, :name => letter)["date"]
      rescue Newslettre::API::ClientFailure
        raise NotScheduledFailure, "not found"
      end

      unless date.nil? or date.size.zero?
        parse_utc_date date
      else
        raise NotScheduledFailure, "invalid date"
      end
    end

    protected

    def parse_utc_date date
      date, time = date.split(" ")

      year, month, day = date.split "-"
      hour, minute, second = time.split ":"

      Time.utc year, month, day, hour, minute, second
    end

  end

  class NotScheduledFailure < Newslettre::API::ClientFailure; end


  class Recipients < Newslettre::APIModule
    attr_reader :letter

    def initialize letter, api
      @letter = letter
      @api = api
    end

    def add list
      request 'add', { :list => list, :name => letter }
    end

    def get
      request 'get', { :name => letter }
    end
    alias_method :list, :get

    def delete list
      request 'delete', { :list => list, :name => letter }
    end
  end

  protected

  def api_prefix
    nil
  end
end
