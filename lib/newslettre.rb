require 'httparty'

module Newslettre
  autoload :Client, 'newslettre/client'
  autoload :APIModule, 'newslettre/api_module'
  autoload :Letter, 'newslettre/letter'
  autoload :Identity, 'newslettre/identity'
  autoload :Lists, 'newslettre/lists'
end
