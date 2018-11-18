
class Factory
  class << self
    def new(*args, &block)
      if args.first.class == String
        const_set(args.shift.capitalize, class_new(*args, &block))
      end
      class_new(*args, &block)
    end

    def class_new(*args, &block)
      Class.new do
        attr_accessor(*args)

        define_method :initialize do |*vals|
          raise ArgumentError.new unless args.count == vals.count
          args.zip(vals).each {|key, val| instance_variable_set("@#{key}", val)}
        end

        class_eval(&block) if block_given?

        def ==(obj)
          self.class == obj.class && self.map_instance == obj.map_instance
        end

        def [](val)
          (val.is_a? Integer) ? map_instance[val] : instance_variable_get("@#{val}")
        end
        
        def map_instance
          instance_variables.map {|var| instance_variable_get(var)}
        end

      end
    end
  end
end
