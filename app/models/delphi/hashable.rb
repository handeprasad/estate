module Delphi
  # FIXME: Everything Hashable should whitelist the attributes it wants to export
  module Hashable
    def self.included base
      base.send :include, InstanceMethods
      base.extend ClassMethods
    end

    module ClassMethods
      def hashable_attrs
        return @hashable_attrs if @hashable_attrs
        instance_methods(false) - [:to_h, :identifier, :searched_for?]
      end

      def hashable *attrs
        @hashable_attrs = attrs
      end
    end

    module InstanceMethods
      def to_h
        {}.tap do |h|
          self.class.hashable_attrs.each { |m| h[m] = self.public_send(m) }
        end
      end
    end
  end
end
