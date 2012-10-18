module Acts
   module Hyperactive
      def self.included(base)
         base.extend ClassMethods
      end

      module ClassMethods
         def acts_as_hyperactive(options = {})
            
            class << self

               def get_with_hyperactive(path, headers = {})

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

            end

            include InstanceMethods
         end
      end
      
      module InstanceMethods

      end
   end
end

ActiveResource::Base.send :include, Acts::Hyperactive