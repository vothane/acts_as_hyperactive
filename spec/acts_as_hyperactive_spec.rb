require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'acts_as_hyperactive' do

  class ActingHyper < ActiveResource::Base
    acts_as_hyperactive
    self.site = "http://www.site.com"
  end


  context "when included" do
    
    it "should included acts_as_hyperactive alias methods" do
      ActingHyper.should respond_to( :connection_with_hyperactive )
    end

  end

  context "when using em-http-request after calling acts_as_hyperactive alias methods" do

    before(:each) do
      stub_request(:get, /.*/).to_return(:body => 'foo', :status => 200)
    end

    before(:all) do
      WebMock::HttpLibAdapters::EmHttpRequestAdapter.enable!
      WebMock.disable_net_connect!
    end

    after(:all) do
      WebMock.allow_net_connect!
    end

    it "should find something" do
      ActiveResource::AsyncConnection.should_receive :get
      EventMachine.run do
        res = ActingHyper.find(1)
        binding.pry
        EventMachine.stop
      end
    end
  end

end