module Acts
   module Hyperactive
      def self.included(base)
         base.extend ClassMethods
      end

      module ClassMethods
         def acts_as_hyperactive(options = {})
            
            class << self

               def get_with_hyperactive(path, headers = {})
                  with_auth do 
                     request_EM(:get, path, build_request_headers(headers, :get, self.site.merge(path))) 
                  end 
               end

               alias_method :get_without_hyperactive, :get
               alias_method :get, :get_with_hyperactive

               def post_with_hyperactive(path, body = '', headers = {})

               end

               alias_method :post_without_hyperactive, :post
               alias_method :post, :post_with_hyperactive

               def put_with_hyperactive(path, body = '', headers = {})

               end

               alias_method :put_without_hyperactive, :put
               alias_method :put, :put_with_hyperactive

               def delete_with_hyperactive(path, headers = {})

               end

               alias_method :delete_without_hyperactive, :delete
               alias_method :delete, :delete_with_hyperactive


              private

              def request_EM(method, path, *arguments)
                url = "#{site.scheme}://#{site.host}:#{site.port}#{path}"
                response = EM::HttpRequest.new(url).send(method, :query => arguments)
                puts response

                response.callback do
                  result = ActiveSupport::Notifications.instrument("request.active_resource") do |payload|
                    payload[:method]      = method
                    payload[:request_uri] = url
                    payload[:result]      = response
                  end

                  succeed(handle_response(result))
                end  

                response.errback do
                  
                end  

                rescue Timeout::Error => e
                  raise TimeoutError.new(e.message)
                rescue OpenSSL::SSL::SSLError => e
                  raise SSLError.new(e.message)  
              end

            end

            include InstanceMethods
         end
      end
      
      module InstanceMethods

      end
   end
end

ActiveResource::Base.send :include, Acts::Hyperactive