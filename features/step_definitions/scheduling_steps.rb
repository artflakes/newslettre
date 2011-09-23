Given /^"([^"]*)" subscribes to "([^"]*)"$/ do |name, list|
  user = NEWSLETTRE_CONFIG['users'][name]

  newslettre.lists.get(list).emails.add user
end

When /^I schedule "([^"]*)" for "([^"]*)"$/ do |letter, date|
  time = Chronic.parse date
  newslettre.newsletters.get(letter).schedule! :at => time
end

Then /^it should deliver "([^"]*)" at "([^"]*)"$/ do |letter, date|
  newslettre.newsletters.get(letter).schedule.should == Chronic.parse(date)
end

Given /^"([^"]*)" is not scheduled$/ do |letter|
  begin
    newslettre.newsletters.get(letter).deschedule!
  rescue Newslettre::API::ClientFailure
    nil
  end
end

When /^I deschedule "([^"]*)"$/ do |letter|
  newslettre.newsletters.get(letter).deschedule!
end

Then /^it should not deliver "([^"]*)"$/ do |letter|
  newslettre.newsletters.get(letter).should_not be_scheduled
end
