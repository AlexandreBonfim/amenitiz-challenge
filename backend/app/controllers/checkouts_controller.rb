class CheckoutsController < ApplicationController
  def create
    catalog = CashRegister::Services::Checkout::DEFAULT_CATALOG
    codes = params.require(:items)

    unless codes.is_a?(Array)
      render json: { error: "items must be an array" }, status: :unprocessable_entity and return
    end

    codes = codes.map(&:to_s)

    if (unknown = codes.find { |code| !catalog.key?(code) })
      render json: { error: "Unknown product: #{unknown}" }, status: :unprocessable_entity and return
    end

    checkout = CashRegister::Services::Checkout.new
    codes.each { |code| checkout.scan(code) }

    render json: {
      items: codes,
      subtotal: checkout.subtotal.to_s("F"),
      discount: checkout.discount.to_s("F"),
      total: checkout.total.to_s("F")
    }, status: :ok
  end
end
