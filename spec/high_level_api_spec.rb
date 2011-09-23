describe "The higher-level API" do
  before :each do
    @client = Newslettre::Client.new(
      NEWSLETTRE_CONFIG['sendgrid']['username'],
      NEWSLETTRE_CONFIG['sendgrid']['password']
    )
  end

  shared_examples_for "an association proxy" do |association|
    let(:proxy) { subject.send(association) }

    it "should return an instance of `APIModuleProxy`" do
      proxy.should be_kind_of(Newslettre::APIModuleProxy)
    end

    it "should set the API on the target" do
      proxy.target.api.should == subject.api
    end

    it "should have the correct target" do
      proxy.target.should be_kind_of(described_class)
    end
  end

  context Newslettre::Identity do
    subject { @client }
    it_should_behave_like "an association proxy", :identities
  end

  context Newslettre::Lists do
    subject { @client }
    it_should_behave_like "an association proxy", :lists

    it "should allow get on the proxy and return a wrapped `Object`" do
      subject.lists.get('test-list').should be_kind_of(Newslettre::Lists::Object)
    end
  end

  context "Lists::Email" do
    subject { @client.lists.get("test-list") }

    it "should cast to_hash" do
      subject.owner.should_receive(:request).and_return([{ "fields" => "some stuff" }])

      subject.to_hash == { "fields" => "some stuff" }
    end

    context Newslettre::Lists::Email do
      it_should_behave_like "an association proxy", :emails

      it "should have set the correct list on the target" do
        subject.emails.target.list.should == "test-list"
      end
    end
  end

  context Newslettre::Letter do
    subject { @client }
    it_should_behave_like "an association proxy", :newsletters

    it "should, when casted to array, return a `list` of elements" do
      subject.newsletters.target.should_receive(:list).and_return([1,2,3])

      subject.newsletters.to_a.should == [1,2,3]
    end

    it "should allow get on the proxy and return an `Object`" do
      subject.newsletters.get('test').should be_kind_of(Newslettre::Letter::Object)
    end
  end

  context "Letter::Object" do
    subject { @client.newsletters.get("Foobar") }

    it "should cast to_hash" do
      subject.owner.should_receive(:request).and_return({ "text" => "some stuff" })

      subject.to_hash == { "text" => "some stuff" }
    end

    context Newslettre::Letter::Recipients do
      it_should_behave_like "an association proxy", :recipients

      it "should have set the correct letter on the target" do
        subject.recipients.target.letter.should == "Foobar"
      end
    end
  end

  context Newslettre::Letter::Schedule do
    subject { @client }

    it "should schedule a newsletter" do
      Timecop.freeze do
        Newslettre::Letter::Schedule.any_instance.should_receive(:deliver).with(:at => Time.now)
        subject.newsletters.get('test-letter').schedule! :at => Time.now
      end
    end

    it "should fetch schedule for newsletter" do
      Newslettre::Letter::Schedule.any_instance.should_receive(:get).and_return(Time.now)
      subject.newsletters.get('test-letter').schedule.should be_kind_of(Time)
    end

    it "should delete schedule for newsletter" do
      Newslettre::Letter::Schedule.any_instance.should_receive(:delete).and_return(true)

      subject.newsletters.get('test-letter').deschedule!.should be_true
    end

    it "should tell me 'test-letter' is not scheduled" do
      Newslettre::API.any_instance.should_receive(:get).and_raise(Newslettre::API::ClientFailure)

      subject.newsletters.get('test-letter').should_not be_scheduled
    end

    it "should tell me 'test-letter' is scheduled" do
      Newslettre::Letter::Schedule.any_instance.should_receive(:get).and_return(Time.now)

      subject.newsletters.get('test-letter').should be_scheduled
    end
  end
end
