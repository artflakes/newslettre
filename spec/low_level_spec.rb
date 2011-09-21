describe Newslettre do
  before :each do
    @api = Newslettre::API.new :email => NEWSLETTRE_CONFIG['sendgrid']['username'],
      :password => NEWSLETTRE_CONFIG['sendgrid']['password']
  end

  describe "#initialize" do
    it "should accept an email and password" do
      @api.should be_kind_of(Newslettre::API)
    end

    it "should set email" do
      @api.email.should == NEWSLETTRE_CONFIG['sendgrid']['username']
    end

    it "should set password" do
      @api.password.should == NEWSLETTRE_CONFIG['sendgrid']['password']
    end

    it "should target `https://sendgrid.com/api/newsletter/`" do
      @api.url.should == "https://sendgrid.com/api/newsletter"
    end
  end

  describe "http actions" do
    use_vcr_cassette

    it "should raise on unauthenticated requests" do
      lambda {
        Newslettre::API.new.list
      }.should raise_error(Newslettre::API::NotAuthenticatedFailure)
    end

    it "should auth requests" do
      @api.list
    end

    it "should raise NotFound on missing resource" do
      lambda {
        VCR.use_cassette('upon raising errors') do
          @api.delete :name => "A Newsletter that will _hopefully_ never, ever exist!"
        end
      }.should raise_error(Newslettre::API::ClientFailure)
    end
  end

  describe Newslettre::Identity do
    use_vcr_cassette

    before :each do
      @identity = Newslettre::Identity.new @api
    end

    it "should list zero identities" do
      @identity.list.each do |i|
        i["identity"].should_not == "test-identity"
      end
    end

    context "with a new identity" do
      use_vcr_cassette
      before :each do
        @identity.add "test-identity", NEWSLETTRE_CONFIG['identity']
      end

      after :each do
        @identity.delete "test-identity"
      end

      it "should create a test-identity" do
        id = @identity.get "test-identity"
        id.should == NEWSLETTRE_CONFIG['identity'].merge("identity" => "test-identity")
      end

    end
  end

  describe Newslettre::Lists do
    use_vcr_cassette

    before :each do
      @lists = Newslettre::Lists.new @api
    end

    it "should list zero test lists" do
      @lists.list.each do |l|
        l["list"].should_not == "test-list"
      end
    end

    context "with a new list" do
      use_vcr_cassette

      before(:each) { @lists.add('test-list') }

      after(:each) { @lists.delete('test-list') }

      it "should create a new list for recipients" do
        list = @lists.get "test-list"

        list.should == {"list" => "test-list"}
      end

    end
  end

  describe Newslettre::Lists::Email do
    use_vcr_cassette

    before :each do
      @lists = Newslettre::Lists.new @api
      @lists.add('test-list')

      @emails = Newslettre::Lists::Email.new 'test-list', @api

      @emails.add *NEWSLETTRE_CONFIG['emails']
    end

    after :each do
      @emails.delete *(NEWSLETTRE_CONFIG['emails'].map{|r| r['email'] })
      @lists.delete 'test-list'
    end

    it "should add two emails to list" do
      emails = @emails.get
      emails.should =~ NEWSLETTRE_CONFIG['emails']
    end

  end

  describe Newslettre::Letter do
    use_vcr_cassette

    before :each do
      @newsletter = Newslettre::Letter.new @api
    end

    it "should have an API" do
      @newsletter.api.should == @api
    end

    it "should list zero test letters" do
      @newsletter.list.each do |l|
        l["name"].should_not == "test"
      end
    end

    context "with a new letter" do
      use_vcr_cassette

      before :each do
        @identity = Newslettre::Identity.new @api
        @identity.add "test-identity", NEWSLETTRE_CONFIG['identity']

        @newsletter.add 'test', NEWSLETTRE_CONFIG['letter']
      end

      after :each do
        @identity.delete "test-identity"
        @newsletter.delete "test"
      end

      it "should create a newsletter" do
        news = @newsletter.get "test"

        news.should == NEWSLETTRE_CONFIG['letter'].merge("name" => 'test')
      end
    end

  end

end
