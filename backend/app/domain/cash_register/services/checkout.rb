require "bigdecimal"
require "bigdecimal/util"

DEFAULT_CATALOG = {
  "GR1" => CashRegister::Entities::Product.new(code: "GR1", name: "Green Tea",    price: 3.11),
  "SR1" => CashRegister::Entities::Product.new(code: "SR1", name: "Strawberries", price: 5.00),
  "CF1" => CashRegister::Entities::Product.new(code: "CF1", name: "Coffee",       price: 11.23)
}.freeze

DEFAULT_PRICING_RULES = [
        CashRegister::Rules::BogoRule.new(product_code: "GR1"),
        CashRegister::Rules::BulkPriceRule.new(
          product_code: "SR1",
          threshold: 3,
          discounted_price: BigDecimal("4.50")
        ),
        CashRegister::Rules::PercentDropAllRule.new(
          product_code: "CF1",
          threshold: 3,
          factor: BigDecimal("2") / BigDecimal("3")
        )
      ].freeze

module CashRegister
  module Services
    class Checkout
      def initialize(pricing_rules: DEFAULT_PRICING_RULES, catalog: DEFAULT_CATALOG)
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
