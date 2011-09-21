require 'httparty'

module Newslettre
  autoload :API, 'newslettre/api'
  autoload :APIModule, 'newslettre/api_module'
  autoload :APIModuleProxy, 'newslettre/api_module_proxy'
  autoload :Client, 'newslettre/client'
  autoload :Letter, 'newslettre/letter'
  autoload :Identity, 'newslettre/identity'
  autoload :Lists, 'newslettre/lists'
end

