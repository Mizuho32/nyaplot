module Ecolirb
  class Diagram
    include Ecolirb::Base
    define_properties(String, :type)
    define_properties(String, :data)
    define_properties(Hash, :options)

    def initialize(&block)
      self.instance_eval(block) if block_given?
    end
  end
end
