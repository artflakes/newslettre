# Newslettre

While writing this [Sendgrid Newsletter API](http://docs.sendgrid.com/documentation/api/newsletter-api/) client in ruby
I noticed several flaws in their __API__ conception. Something like,
returning __401__ Status code when resources cannot be found are pretty
gross but anyway this client should be mostly complete (still work in
progress, scheduling etc.).

## Installation

``` ruby

gem install newslettre

```

## Usage

<del>this is definitely going to change since it's tedious to pass the client
instance around. Maybe there will be a top-level wrapper to give you
access to all the _modules_ the API defines (Identity, Newsletter,
Recipients)</del>

Right now it works like this…

``` ruby

require 'newslettre'

client = Newslettre::Client.new "somebody@yourdomain.com", "reallygoodpassword"
  
# Accessing newsletters
  
client.newsletters.to_a # => [{ "name" => "webdev" }] 
  
client.newsletters.get("webdev") # => { "name", "subject" => "Latest Web Development News", "html" =>  "<html>...</html>" }

client.newsletters.delete "webdev"

# Accessing recipients of a newsletter

client.newsletters.get("webdev").recipients.to_a # => [{ "list" => "web-developers" }]
  
client.newsletters.get("webdev").recipients.delete "web-developers"
  
```

<del>nearly the same goes for `Identity`, `Lists`, `Lists::Email` and `Letter::Recipients`</del>

You can also use `#lists` and `#identities` as well as the nested emails in recipient lists.

``` ruby

client.lists.get("web-developers").emails.delete "selective@hosted.com", "programmatic@failure.com"
  
```

Last but not least, to schedule an already existing newsletter:

``` ruby

client.newsletters.get("webdev").schedule! :at => Time.now

# to see when a newsletter will be delivered

client.newsletters.get("webdev").schedule # => Mon Sep 26 14:01:13 +0200 2011

# and to deschedule again

client.newsletters.get("webdev").deschedule!
    
```

## Development

though it is still far from complete, if you'd like to help out please
submit pull request with passing specs (or scenarios)

you will need to add a `config/newslettre.yml` containing something like
this:

``` yaml
sendgrid:
  username: "somebody@yourdomain.com"
  password: "reallysecurepassword"

identity:
  email: "info@yourdomain.com"
  name: "Lennart Melzer"
  address: "Where you live 15"
  city: "Downtown"
  state: "C"
  zip: "12345"
  country: "EF"

letter:
  name: "test"
  identity: "test-identity"
  subject: "A letter to the world!"
  html: "<html><body><h1>A rendered Headline</h1></body></html>"
  text: "An unrendered Headline"

emails:
  -
    email: somebody@yourdomain.com
    name: Some Body
  -
    email: someone@else.com
    name: Someone Else

```

to make the specs pass 
