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

  end

  context "with a new list" do
    use_vcr_cassette

    subject { Newslettre::Lists.new @api }

    before(:each) { subject.add('test-list') }

    after(:each) { subject.delete('test-list') }

    it "should create a new list for recipients" do
      list = subject.get "test-list"

      list.should == {"list" => "test-list"}
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

    context "with a long letter" do
      use_vcr_cassette


      before :each do
        @identity = Newslettre::Identity.new @api
        @identity.add "test-identity", NEWSLETTRE_CONFIG['identity']

      end

      after :each do
        @identity.delete "test-identity"

      end

      it "should create an HTML mail" do
        data = NEWSLETTRE_CONFIG['letter']
        data["html"] = File.read File.dirname(__FILE__) + "/fixtures/test-letter.html"
        #html = <<-HTML
        #    <!doctype html>\n<!-- paulirish.com/2008/conditional-stylesheets-vs-css-hacks-answer-neither/ -->\n<!--[if lt IE 7]> <html class=\"no-js ie6 oldie\" lang=\"en\"> <![endif]-->\n<!--[if IE 7]>    <html class=\"no-js ie7 oldie\" lang=\"en\"> <![endif]-->\n<!--[if IE 8]>    <html class=\"no-js ie8 oldie\" lang=\"en\"> <![endif]-->\n<!-- Consider adding a manifest.appcache: h5bp.com/d/Offline -->\n<!--[if gt IE 8]><!--> <html class=\"no-js\" lang=\"en\"> <!--<![endif]-->\n<head>\n  <meta charset=\"utf-8\">\n\n  <!-- Use the .htaccess and remove these lines to avoid edge case issues.\n       More info: h5bp.com/b/378 -->\n  <meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge,chrome=1\">\n\n  <title></title>\n  <meta name=\"description\" content=\"\">\n  <meta name=\"author\" content=\"\">\n\n  <!-- Mobile viewport optimized: j.mp/bplateviewport -->\n  <meta name=\"viewport\" content=\"width=device-width,initial-scale=1\">\n\n  <!-- Place favicon.ico and apple-touch-icon.png in the root directory: mathiasbynens.be/notes/touch-icons -->\n\n  <link rel=\"stylesheet\" href=\"css/style.css\">\n  \n  <!-- More ideas for your <head> here: h5bp.com/d/head-Tips -->\n\n  <!-- All JavaScript at the bottom, except this Modernizr build incl. Respond.js\n       Respond is a polyfill for min/max-width media queries. Modernizr enables HTML5 elements & feature detects; \n       for optimal performance, create your own custom Modernizr build: www.modernizr.com/download/ -->\n  <script src=\"js/libs/modernizr-2.0.6.min.js\"></script>\n</head>\n\n<body>\n  <header>\n\n  </header>\n  <div role=\"main\">\n\n  </div>\n  <footer>\n\n  </footer>\n\n\n  <!-- JavaScript at the bottom for fast page loading -->\n\n  <!-- Grab Google CDN's jQuery, with a protocol relative URL; fall back to local if offline -->\n  <script src=\"//ajax.googleapis.com/ajax/libs/jquery/1.6.4/jquery.min.js\"></script>\n  <script>window.jQuery || document.write('<script src=\"js/libs/jquery-1.6.4.min.js\"><\\/script>')</script>\n\n\n  <!-- scripts concatenated and minified via build script -->\n  <script defer src=\"js/plugins.js\"></script>\n  <script defer src=\"js/script.js\"></script>\n  <!-- end scripts -->\n\n\n  <!-- Asynchronous Google Analytics snippet. Change UA-XXXXX-X to be your site's ID.\n       mathiasbynens.be/notes/async-analytics-snippet -->\n  <script>\n    var _gaq=[['_setAccount','UA-XXXXX-X'],['_trackPageview'],['_trackPageLoadTime']];\n    (function(d,t){var g=d.createElement(t),s=d.getElementsByTagName(t)[0];\n    g.src=('https:'==location.protocol?'//ssl':'//www')+'.google-analytics.com/ga.js';\n    s.parentNode.insertBefore(g,s)}(document,'script'));\n  </script>\n\n  <!-- Prompt IE 6 users to install Chrome Frame. Remove this if you want to support IE 6.\n       chromium.org/developers/how-tos/chrome-frame-getting-started -->\n  <!--[if lt IE 7 ]>\n    <script defer src=\"//ajax.googleapis.com/ajax/libs/chrome-frame/1.0.3/CFInstall.min.js\"></script>\n    <script defer>window.attachEvent('onload',function(){CFInstall.check({mode:'overlay'})})</script>\n  <![endif]-->\n\n</body>\n</html>\n
        #    HTML
        @newsletter.add 'test-html', data

        @newsletter.get("test-html").to_hash["html"].should_not be_empty

        # and then delete it
        @newsletter.delete "test-html"
      end
    end


  end

end
