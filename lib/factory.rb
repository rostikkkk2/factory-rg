
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

        define_method :initialize do |*values|
          raise ArgumentError.new unless args.count == values.count
          args.zip(values).each {|l, n| instance_variable_set("@#{l}", n)}
        end

      end
    end
  end
end

# * Instance of creatable Factory class should correctly respond to main methods of Struct
# - each
# - each_pair
# - dig
# - size/length
# - members
# - select
# - to_a
# - values_at
# - ==, eql?
