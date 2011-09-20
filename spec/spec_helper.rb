require File.dirname(__FILE__) + '/../lib/newslettre'

require 'vcr'

NEWSLETTRE_CONFIG = YAML.load_file File.dirname(__FILE__) + "/../config/newslettre.yml"

VCR.config do |c|
  c.cassette_library_dir = "spec/cassettes"
  c.stub_with :webmock
  c.filter_sensitive_data('<<USERNAME>>') { NEWSLETTRE_CONFIG['sendgrid']['username'] }
  c.filter_sensitive_data('<<PASSWORD>>') { NEWSLETTRE_CONFIG['sendgrid']['password'] }
  c.default_cassette_options = { :record => :once }
end

RSpec.configure do |c|
  c.extend VCR::RSpec::Macros
end
