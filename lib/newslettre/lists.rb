class Newslettre::Lists < Newslettre::APIModule
  def add list, data = {}
    request 'add', data.merge(:list => list)
  end

  def get list = nil
    if list.nil?
      request 'get'
    else
      request('get', :list => list).first
    end
  end
  alias_method :list, :get

  def edit list, data = {}
    request 'edit', data.merge(:list => list)
  end

  def delete list
    request 'delete', :list => list
  end

  class Email < Newslettre::APIModule
    attr_reader :list

    def initialize list, client
      @client = client
      @list = list
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
