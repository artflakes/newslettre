Given /^there is no Newsletter named "([^"]+)"$/ do |name|
  begin
    newslettre.newsletters.delete name
  rescue Newslettre::API::ClientFailure
    nil
  end
end

Given /^there is no "([^"]+)" Recipient List$/ do |list|
  begin
    newslettre.lists.delete list
  rescue Newslettre::API::ClientFailure
    nil
  end
end

Given /^there is no identity named "([^"]+)"$/ do |identity|
  begin
    newslettre.identities.delete identity
  rescue Newslettre::API::ClientFailure
    nil
  end
end

Given /^I add the "([^"]+)" Identity$/ do |identity|
  newslettre.identities.add identity, NEWSLETTRE_CONFIG['identity']
end

Given /^I add a Newsletter named "([^"]+)" written by "([^"]+)"$/ do |name, identity|
  newslettre.newsletters.add name,
    :identity => identity,
    :subject => name,
    :text => "Super Cool!",
    :html => "<h1>meow</h1>"
end

Given /^I add a Recipient List named "([^"]+)"$/ do |list|
  newslettre.lists.add list
end

When /^I add "([^"]+)" to "([^"]+)"$/ do |list, name|
  newslettre.newsletters.get(name).recipients.add list
end

When /^I remove "([^"]+)" from "([^"]+)"$/ do |list, name|
  newslettre.newsletters.get(name).recipients.delete list
end

Then /^"([^"]+)" will be notified when "([^"]+)" is delivered$/ do |list, name|
  newslettre.newsletters.get(name).recipients.to_a.should =~ [{ "list" => list }]
end

Then /^no one will be notified when "([^"]+)" is delivered$/ do |name|
  newslettre.newsletters.get(name).recipients.to_a.should be_empty
end
