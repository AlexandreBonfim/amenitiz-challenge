require "bigdecimal"

module CashRegister
  module Entities
    class Product
      attr_reader :code, :name, :price

      def initialize(code:, name:, price:)
        @code  = code
        @name  = name
        @price = BigDecimal(price.to_s)
      end
    end
  end
end
