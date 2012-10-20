require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'acts_as_hyperactive' do 

  class ActingHyper < ActiveResource::Base
    acts_as_hyperactive
    self.site = "http://localhost:3000"
  end

  context "when included" do

    let(:connection) do
      ActingHyper::ActiveResource::Connection
    end 
    
    it "should modifiy ActiveResource" do
      connection.should be_a( Acts::Hyperactive )
    end
    
    it "should included acts_as_hyperactive alias methods" do
      ActingHyper.should respond_to( :get_with_hyperactive )
      ActingHyper.should respond_to( :post_with_hyperactive )
      ActingHyper.should respond_to( :put_with_hyperactive )
      ActingHyper.should respond_to( :delete_with_hyperactive )
    end
    
  end

  context "when using em-http-request after calling acts_as_hyperactive alias methods" do

    before(:all) do
      WebMock.disable_net_connect!
    end  
    
    after(:all) do
      WebMock.disable_net_connect!
    end  

    it "should find something" do
      stub_request(:get, 'http://localhost:3000/acting_hypers/1.json').
      with(:headers=>{'Accept'=>'application/json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3','User-Agent'=>'Ruby'}).
      to_return do |request|
        response = {:id => 1, :data => "blah"}.to_json
        {:body => response, :status => 200}
      end

      ActingHyper.find(1).should_not be_nil  
    end
  end  
  
end