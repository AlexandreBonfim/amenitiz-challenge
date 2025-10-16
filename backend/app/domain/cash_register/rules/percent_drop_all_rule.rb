require_relative "rule"

module CashRegister
  module Rules
    # When threshold met, all units of the product drop to (factor * original price)
    class PercentDropAllRule < Rule
      def initialize(product_code:, threshold:, factor:)
        @product_code = product_code
        @threshold    = threshold
        @factor       = BigDecimal(factor.to_s)
      end

      def apply(items)
        matching = items.select { |p| p.code == @product_code }

        return 0.to_d if matching.count < @threshold

        unit_price = matching.first.price
        full_price_total = unit_price * matching.count
        discounted_total = (full_price_total * @factor).round(2)
        (full_price_total - discounted_total).round(2)
      end
    end
  end
end
