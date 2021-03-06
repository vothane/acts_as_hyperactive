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

  context "when instantiating a connection" do
    
    it "should be an instance of AsyncConnection" do
      ActingHyper.connection.should be_a( ActiveResource::AsyncConnection )
    end

  end

  context "when using em-http-request for http get requests" do

    before(:each) do
      stub_request(:get, /.*/).to_return(:body => {:id => 1, :data => "foo"}, :status => 200)
    end
    
    before(:all) do
      WebMock::HttpLibAdapters::EmHttpRequestAdapter.enable!
      WebMock.disable_net_connect!
    end

    after(:all) do
      WebMock.allow_net_connect!
    end

    it "should asynchronously find data that is given by WebMock" do 

      EventMachine.should_receive :defer

      EventMachine.run do
        result = ActingHyper.find(1)
        result.id.should == 1
        result.data.should == "foo"
        EventMachine.stop
      end

    end
  end

  context "when using em-http-request for http post requests (creating)" do

    before(:each) do
      stub_request(:post, /.*/).to_return({:body => {:save => true}}, :status => 201)
    end
    
    before(:all) do
      WebMock::HttpLibAdapters::EmHttpRequestAdapter.enable!
      WebMock.disable_net_connect!
    end

    after(:all) do
      WebMock.allow_net_connect!
    end

    it "should asynchronously save data" do 

      EventMachine.should_receive :defer
      
      EventMachine.run do
        act_hyper = ActingHyper.new({ :id => 1, :name => "Matz" })
        act_hyper.save.should be_true
        EventMachine.stop
      end

    end
  end

  context "when using em-http-request for http put requests (updating)" do

    before(:each) do
      stub_request(:get, /.*/).to_return(:body => {:id => 1, :data => "foo"}, :status => 200)
      stub_request(:put, /.*/).to_return({:body => {:updated => nil}}, :status => 204)
    end
    
    before(:all) do
      WebMock::HttpLibAdapters::EmHttpRequestAdapter.enable!
      WebMock.disable_net_connect!
    end

    after(:all) do
      WebMock.allow_net_connect!
    end

    it "should asynchronously update data" do 

      EventMachine.should_receive( :defer ).twice
      
      EventMachine.run do
        act_hyper = ActingHyper.find(1)
        act_hyper.id.should == 1
        act_hyper.data.should == "foo"

        act_hyper.data = "foobar"
        act_hyper.save.should be_true
        EventMachine.stop
      end

    end
  end

  context "when using em-http-request for http delete requests (destroying)" do

    before(:each) do
      stub_request(:get, /.*/).to_return(:body => {:id => 1, :data => "foo"}, :status => 200)
      stub_request(:delete, /.*/).to_return({:body => {:deleted => nil}}, :status => 200)
    end
    
    before(:all) do
      WebMock::HttpLibAdapters::EmHttpRequestAdapter.enable!
      WebMock.disable_net_connect!
    end

    after(:all) do
      WebMock.allow_net_connect!
    end

    it "should asynchronously destroy data" do 

      EventMachine.should_receive( :defer ).twice
      
      EventMachine.run do
        act_hyper = ActingHyper.find(1)
        act_hyper.id.should == 1
        act_hyper.data.should == "foo"

        act_hyper.destroy.should be_true
        EventMachine.stop
      end

    end
  end
end