class Rekord::Base
  def initialize(**args, &block)
    send(:'props=', args, &block)
  end

  def props
    instance_variables.each_with_object({}) do |varible_name, hash|
      hash[ varible_name.to_s[1..-1].to_sym ] = instance_variable_get varible_name
    end
  end

  def props=(**new_props, &block)
    if block_given?
      block.call(self)
    else
      new_props.each do |variable, value|
        send("#{variable}=".to_sym, value)
      end
    end
  end

  class << self
    def prop(prop_name)
      define_variable prop_name, nil
      define_reader prop_name
      define_writer prop_name
    end

    def define_variable(prop_name, value=nil)
      varible_name = "@#{prop_name}".to_sym
      instance_variable_set varible_name, value
    end

    def define_reader(prop_name)
      define_method prop_name do
        instance_variable_get "@#{prop_name}"
      end
    end

    def define_writer(prop_name)

      define_method "#{prop_name}=" do |val|
        instance_variable_set "@#{prop_name}", val
      end
    end
  end
end
