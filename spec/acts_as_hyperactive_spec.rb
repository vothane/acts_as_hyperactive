require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'acts_as_hyperactive' do 

  context "when included" do

    class ActingHyper < ActiveResource::Base
      acts_as_hyperactive
      self.site = "http://localhost:3000"
    end

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
  
end