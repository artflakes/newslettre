class Newslettre::Lists < Newslettre::APIModule
  class Object < Struct.new(:owner, :list, :data)
    extend Forwardable

    def_delegator :owner, :request
    def_delegator :owner, :api

    def == other
      self.to_hash == other
    end

    def load_data
      self.data ||= request('get', :list => self.list).first.to_hash
    end

    def to_hash
      load_data

      data
    end

    def emails
      @emails ||= Newslettre::APIModuleProxy.new self, Email.new(self.list, self.api)
    end
  end

  def add list, data = {}
    request 'add', data.merge(:list => list)
  end

  def get list
    Object.new self, list
  end

  def list
    request('get').map {|r|
      Object.new self, r["list"]
    }
  end


  def edit list, data = {}
    request 'edit', data.merge(:list => list)
  end

  def delete list
    request 'delete', :list => list
  end

  class Email < Newslettre::APIModule
    attr_reader :list

    def initialize list, api
      @list = list
      @api = api
    end

    def add *recipients
      request 'add', :list => list, :data => recipients.map{|r| JSON.dump(r) }
    end

    def get *recipients
      request 'get', :list => list, :email => recipients
    end

    def delete *recipients
      request 'delete', :list => list, :email => recipients
    end

    protected

    def api_prefix
      "/lists/email"
    end
  end
end
