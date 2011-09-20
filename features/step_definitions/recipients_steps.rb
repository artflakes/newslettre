Given /^there is no Newsletter named '([^']+)'$/ do |name|
  begin
    Newslettre::Letter.new(newslettre).delete name
  rescue Newslettre::Client::ClientFailure
    nil
  end
end

Given /^there is no '([^']+)' Recipient List$/ do |list|
  begin
    Newslettre::Lists.new(newslettre).delete list
  rescue Newslettre::Client::ClientFailure
    nil
  end
end

Given /^there is no identity named '([^']+)'$/ do |identity|
  begin
    Newslettre::Identity.new(newslettre).delete identity
  rescue Newslettre::Client::ClientFailure
    nil
  end
end

Given /^I add the '([^']+)' Identity$/ do |identity|
  Newslettre::Identity.new(newslettre).add identity, NEWSLETTRE_CONFIG['identity']
end

Given /^I add a Newsletter named '([^']+)' written by '([^']+)'$/ do |name, identity|
  Newslettre::Letter.new(newslettre).add name,
    :identity => identity,
    :subject => name,
    :text => "Super Cool!",
    :html => "<h1>meow</h1>"
end

Given /^I add a Recipient List named '([^']+)'$/ do |list|
  Newslettre::Lists.new(newslettre).add list
end

When /^I add '([^']+)' to '([^']+)'$/ do |list, name|
  recipients = Newslettre::Letter::Recipients.new name, newslettre

  recipients.add list
end

When /^I remove '([^']+)' from '([^']+)'$/ do |list, name|
  recipients = Newslettre::Letter::Recipients.new name, newslettre

  recipients.delete list
end

Then /^'([^']+)' will be notified when '([^']+)' is delivered$/ do |list, name|
  recipients = Newslettre::Letter::Recipients.new name, newslettre
  lists = recipients.get
  lists.should =~ [{ "list" => list }]
end

Then /^no one will be notified when '([^']+)' is delivered$/ do |name|
  recipients = Newslettre::Letter::Recipients.new name, newslettre
  lists = recipients.get
  lists.should be_empty
end
