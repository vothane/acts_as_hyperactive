module Acts
  module Hyperactive
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods

      def acts_as_hyperactive(options = {})

        class << self
          def connection_with_hyperactive(refresh = false)
            if defined?(@connection) || superclass == Object
              @connection = ActiveResource::AsyncConnection.new(site, format) if refresh || @connection.nil?
              @connection.proxy = proxy if proxy
              @connection.user = user if user
              @connection.password = password if password
              @connection.auth_type = auth_type if auth_type
              @connection.timeout = timeout if timeout
              @connection.ssl_options = ssl_options if ssl_options
              @connection
            else
              superclass.connection
            end
          end

          alias_method :connection_without_hyperactive, :connection
          alias_method :connection, :connection_with_hyperactive
          
        end

        include InstanceMethods
      end
    end

    module InstanceMethods

    end
  end
end

ActiveResource::Base.send :include, Acts::Hyperactive