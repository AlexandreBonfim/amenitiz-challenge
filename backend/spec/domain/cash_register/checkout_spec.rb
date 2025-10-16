require "spec_helper"
require "bigdecimal"
require "bigdecimal/util"

RSpec.describe CashRegister::Services::Checkout do
  let(:green_tea) { CashRegister::Entities::Product.new(code: "GR1", name: "Green Tea", price: 3.11) }
  let(:strawberries) { CashRegister::Entities::Product.new(code: "SR1", name: "Strawberries", price: 5.00) }
  let(:coffee) { CashRegister::Entities::Product.new(code: "CF1", name: "Coffee", price: 11.23) }

  let(:base_catalog) { { "GR1" => green_tea } }
  let(:bogo_rule) { CashRegister::Rules::BogoRule.new(product_code: "GR1") }
  let(:bulk_rule) do
    CashRegister::Rules::BulkPriceRule.new(
      product_code: "SR1",
      threshold: 3,
      discounted_price: BigDecimal("4.50")
    )
  end
  let(:percent_rule) do
    CashRegister::Rules::PercentDropAllRule.new(
      product_code: "CF1",
      threshold: 3,
      factor: BigDecimal("2") / BigDecimal("3")
    )
  end

  let(:catalog) { base_catalog }
  let(:pricing_rules) { [bogo_rule, bulk_rule, percent_rule] }

  subject(:checkout) { described_class.new(pricing_rules: pricing_rules, catalog: catalog) }

  context "without any pricing rules" do
    let(:pricing_rules) { [] }

    it "charges the full price for scanned items" do
      %w[GR1 GR1].each { |code| checkout.scan(code) }

      expect(checkout.total).to eq(6.22.to_d)
    end
  end

  context "with only the BOGO rule for green tea" do
    let(:pricing_rules) { [bogo_rule] }

    it "charges 3.11 for two green teas" do
      checkout.scan("GR1").scan("GR1")

      expect(checkout.total).to eq(3.11.to_d)
    end
  end

  context "with a bulk discount on strawberries" do
    let(:catalog) { base_catalog.merge("SR1" => strawberries) }
    let(:pricing_rules) { [bulk_rule] }

    it "drops the total to 16.61 for the SR1 basket" do
      %w[SR1 SR1 GR1 SR1].each { |code| checkout.scan(code) }

      expect(checkout.total).to eq(16.61.to_d)
    end
  end

  context "with a percentage drop on coffee" do
    let(:catalog) { base_catalog.merge("SR1" => strawberries, "CF1" => coffee) }
    let(:pricing_rules) { [percent_rule] }

    it "totals 30.57 for the mixed coffee basket" do
      %w[GR1 CF1 SR1 CF1 CF1].each { |code| checkout.scan(code) }

      expect(checkout.total).to eq(30.57.to_d)
    end
  end

  context "with a all rules" do
    let(:catalog) { base_catalog.merge("SR1" => strawberries, "CF1" => coffee) }
    let(:pricing_rules) { [bogo_rule, bulk_rule, percent_rule] }

    it "totals 39.07 for the mixed products" do
      %w[GR1 CF1 SR1 CF1 CF1 GR1 SR1 SR1].each { |code| checkout.scan(code) }

      expect(checkout.total).to eq(39.07.to_d)
    end
  end
end
