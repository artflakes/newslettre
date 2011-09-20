class Newslettre::Identity < Newslettre::APIModule
  def list
    request 'list'
  end

  def get id
    request 'get', :identity => id
  end

  def add id, data = {}
    request 'add', data.merge(:identity => id)
  end

  def edit id, data = {}
    request 'edit', data.merge(:identity => id)
  end

  def delete id
    request 'delete', :identity => id
  end
end
