require 'rekord/prop'

module Rekord
  module PropMethods
    def self.included(base)
      base.extend(ClassMethods)
    end

    def initialize(**args)
      define_props!

      args.each do |prop, val|
        send("#{prop}=", val)
      end

      yield self if block_given?
    end

    def props
      self.class.propdefs.each_with_object({}) do |prop_name, hash|
        hash[ prop_name ] = send(prop_name)
      end
    end

    def props=(**new_props)
      new_props.each do |variable, value|
        send("#{variable}=", value)
      end
    end

    private

    def define_props!
      self.class.propdefs.each do |propdef|
        instance_variable_set("@#{propdef}", Prop.new(nil))
      end
    end

    module ClassMethods
      def prop(prop_name)
        define_prop prop_name
        define_reader prop_name
        define_writer prop_name
      end

      def propdefs
        @propdefs
      end

      protected

      def define_prop(prop_name)
        (@propdefs ||= []) << prop_name
      end

      def define_reader(prop_name)
        define_method prop_name do
          instance_variable_get("@#{prop_name}").get
        end
      end

      def define_writer(prop_name)
        define_method "#{prop_name}=" do |value|
          instance_variable_get("@#{prop_name}").set value
        end
      end
    end
  end
end
