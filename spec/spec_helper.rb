require File.dirname(__FILE__) + '/../lib/newslettre'

require 'vcr'
require 'rspec-spies'
require 'timecop'

NEWSLETTRE_CONFIG = YAML.load_file File.dirname(__FILE__) + "/../config/newslettre.yml"

VCR.config do |c|
  c.cassette_library_dir = "spec/cassettes"
  c.stub_with :webmock
  c.filter_sensitive_data('<<USERNAME>>') { Curl::PostField.content "api_user", NEWSLETTRE_CONFIG['sendgrid']['username'] }
  c.filter_sensitive_data('<<PASSWORD>>') { Curl::PostField.content "api_key", NEWSLETTRE_CONFIG['sendgrid']['password'] }
  c.default_cassette_options = { :record => :once }
end

RSpec.configure do |c|
  c.extend VCR::RSpec::Macros
end
