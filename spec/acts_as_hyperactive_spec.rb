require File.expand_path(File.dirname(__FILE__) + '/spec_helper')


describe 'acts_as_hyperactive' do 

  context "when included" do
    
    it "should modifiy ActiveResource" do
      ActiveResource::Connection.should be_a( Acts::Hyperactive )
    end
    
    it "should included acts_as_hyperactive alias methods" do
      ActiveResource::Connection.should respond_to( :get_with_hyperactive )
      ActiveResource::Connection.should respond_to( :post_with_hyperactive )
      ActiveResource::Connection.should respond_to( :put_with_hyperactive )
      ActiveResource::Connection.should respond_to( :delete_with_hyperactive )
    end
    
  end
	
end