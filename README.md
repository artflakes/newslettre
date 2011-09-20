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

this is definitely going to change since it's tedious to pass the client
instance around. Maybe there will be a top-level wrapper to give you
access to all the _modules_ the API defines (Identity, Newsletter,
Recipients)

Right now it works like this…

``` ruby

  require 'newslettre'

  client = Newslettre::Client.new :email => "somebody@yourdomain.com",
  :password => "reallygoodpassword"

  letters = Newslettre::Letter.new client

  letters.list # => [{ "name" => "webdev" }] 


  letters.get "webdev" # => { "name", "subject" => "Latest Web Development News", "html" =>  "<html>...</html>" }

  letters.delete "webdev"

```

nearly the same goes for `Identity`, `Lists`, `Lists::Email` and `Letter::Recipients`

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
