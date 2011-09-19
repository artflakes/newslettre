require 'spec_helper'

describe Newslettre::Client do
  before :each do
    @client = Newslettre::Client.new :email => "me@myself.com", :password => "supersecure"
  end

  describe "#initialize" do
    it "should accept an email and password" do
      @client.should be_kind_of(Newslettre::Client)
    end

    it "should set email" do
      @client.email.should == "me@myself.com"
    end

    it "should set password" do
      @client.password.should == "supersecure"
    end

    it "should target `https://sendgrid.com/api/newsletter/`" do
      @client.url.should == "https://sendgrid.com/api/newsletter/"
    end
  end

  describe "#newsletters" do
    it "should be a list" do
      pending {
        @client.newsletters.should be_respond_to(:<<)
      }
    end
  end

  describe Newslettre::Newsletter do

  end
end
