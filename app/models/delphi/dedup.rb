module Delphi
  module Dedup
    def self.included base
      base.send :include, Comparable
      base.send :include, InstanceMethods
      base.extend ClassMethods
    end

    module ClassMethods
      def identifier *attributes
        define_method :identifier do
          ([ "class:#{self.class.name}" ] + attributes.map(&:to_s).sort.map { |a| "#{a}:#{__send__(a)}" }).join('::')
        end
      end
    end

    module InstanceMethods
      def <=>(other)
        identifier <=> other.identifier
      end

      def eql?(other)
        self.class == other.class && self == other
      end

      def hash
        identifier.hash
      end
    end
  end
end
