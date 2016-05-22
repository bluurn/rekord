module Rekord
  module Config
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def config
        @config ||= Struct.new(:storage).new
      end

      def configure
        yield config if block_given?
      end
    end
  end
end

