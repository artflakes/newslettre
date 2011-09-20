NEWSLETTRE_CONFIG = YAML.load_file File.dirname(__FILE__) + "/../../config/newslettre.yml"

require 'vcr'
require 'newslettre'

VCR.config do |c|
  c.stub_with :webmock
  c.cassette_library_dir = 'features/cassettes'
  c.filter_sensitive_data('<<USERNAME>>') { NEWSLETTRE_CONFIG['sendgrid']['username'] }
  c.filter_sensitive_data('<<PASSWORD>>') { NEWSLETTRE_CONFIG['sendgrid']['password'] }
  c.default_cassette_options = { :record => :once }
end

VCR.cucumber_tags do |t|
  t.tags '@sendgrid_adding_recipients', '@sendgrid_removing_recipients'
end

class OuterWorld
  def newslettre
    @newslettre ||= Newslettre::Client.new(:email => NEWSLETTRE_CONFIG['sendgrid']['username'],
                           :password => NEWSLETTRE_CONFIG['sendgrid']['password'])
  end
end

World { OuterWorld.new }
