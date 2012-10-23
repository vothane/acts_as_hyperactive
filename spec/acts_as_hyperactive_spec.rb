require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'acts_as_hyperactive' do

  class ActingHyper < ActiveResource::Base
    acts_as_hyperactive
    self.site = "http://localhost:3000"
  end


  context "when included" do
    
    it "should included acts_as_hyperactive alias methods" do
      ActingHyper.should respond_to( :connection_with_hyperactive )
    end

  end

  context "when using em-http-request after calling acts_as_hyperactive alias methods" do

    before(:each) do
      stub_request(:get, 'http://localhost:3000/acting_hypers/1.json').
          with(:headers => {'Accept' => 'application/json', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent' => 'Ruby'}).
          to_return do |request|
        response = {:id => 1, :data => "blah"}.to_json
        {:body => response, :status => 200}
      end
    end

    before(:all) do
      WebMock.disable_net_connect!
    end

    after(:all) do
      WebMock.allow_net_connect!
    end

    it "should find something" do
      ActiveResource::AsyncConnection.should_receive :get
      EventMachine.run do
        res = ActingHyper.find(1)
        EventMachine.stop
      end 
      binding.pry
      res.should_not be_nil 
    end
  end

end