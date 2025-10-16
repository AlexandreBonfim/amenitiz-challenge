require "bigdecimal/util"

module CashRegister
  module Services
    class Checkout
      def initialize(pricing_rules: [], catalog: {})
        @pricing_rules = pricing_rules
        @catalog       = catalog
        @items         = []
      end

      def scan(code)
        product = @catalog.fetch(code) { raise ArgumentError, "Unknown product: #{code}" }
        @items << product
        self
      end

      def subtotal
        @items.map(&:price).reduce(0.to_d, :+).round(2)
      end

      def discount
        @pricing_rules.map { |r| r.apply(@items) }.reduce(0.to_d, :+).round(2)
      end

      def total
        (subtotal - discount).round(2)
      end
    end
  end
end
