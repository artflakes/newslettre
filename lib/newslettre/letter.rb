class Newslettre::Letter < Newslettre::APIModule
  def list
    request 'list'
  end

  def add name, data = {}
    request 'add', data.merge(:name => name)
  end

  def get name
    request 'get', :name => name
  end

  def delete name
    request 'delete', :name => name
  end

  def edit name, data = {}
    request 'edit', data
  end

  class Recipients < Newslettre::APIModule
    attr_reader :letter

    def initialize letter, client
      @letter = letter
      @client = client
    end

    def add list
      request 'add', { :list => list, :name => letter }
    end

    def get
      request 'get', { :name => letter }
    end

    def delete list
      request 'delete', { :list => list, :name => letter }
    end
  end

  protected

  def api_prefix
    nil
  end
end
