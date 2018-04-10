module ArrayToSelfConvert
  def self.included(_klass)
    methods = ::Array.public_instance_methods(true) - ::Kernel.public_instance_methods(false)
    methods |= ['to_s', 'to_a', 'inspect', '==', '=~', '===']
    methods.each do |method|
      define_method(method) do |*args, &block|
        res = super(*args, &block)
        if res.class == Array && method != 'to_a'
          cloned = deep_clone ? Marshal.load(Marshal.dump(self)) : dup
          cloned.clear.concat(res)
        else
          res
        end
      end
    end
  end
  attr_accessor :deep_clone
end
