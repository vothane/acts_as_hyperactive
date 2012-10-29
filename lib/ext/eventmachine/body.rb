['EventMachine::HttpClient', 'EventMachine::WebMockHttpClient'].each do |klass|                     
  klass.constantize.class_eval do
    def body
      if @stubbed_webmock_response
        return { :body => @stubbed_webmock_response.body }.to_json
      else  
        if @response == ""
          return { :body => "" }.to_json
        else
          return { :body => @response }.to_json
        end  
      end  
    end  
  end  
end            