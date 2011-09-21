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

    def recipients
      @recipients ||= Newslettre::APIModuleProxy.new self, Recipients.new(self.name, self.api)
    end
  end

  def list
    request 'list'
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
