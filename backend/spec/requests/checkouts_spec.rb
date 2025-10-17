require "rails_helper"

RSpec.describe "Checkouts controller", type: :request do
  def checkout(items)
    post "/checkout", params: { items: items }, as: :json
    expect(response).to have_http_status(:ok)
    JSON.parse(response.body)
  end

  it "returns totals for two green teas with BOGO discount" do
    body = checkout(%w[GR1 GR1])

    expect(body["items"]).to eq(%w[GR1 GR1])
    expect(body["subtotal"]).to eq("6.22")
    expect(body["discount"]).to eq("3.11")
    expect(body["total"]).to eq("3.11")
  end

  it "applies SR1 bulk discount when three strawberries bought" do
    body = checkout(%w[SR1 SR1 GR1 SR1])

    expect(body["items"]).to eq(%w[SR1 SR1 GR1 SR1])
    expect(body["total"]).to eq("16.61")
  end

  it "applies CF1 two-thirds price drop when three coffees bought" do
    body = checkout(%w[GR1 CF1 SR1 CF1 CF1])

    expect(body["items"]).to eq(%w[GR1 CF1 SR1 CF1 CF1])
    expect(body["total"]).to eq("30.57")
  end

  it "rejects payloads with unknown product codes" do
    post "/checkout", params: { items: %w[GR1 XYZ] }, as: :json

    expect(response).to have_http_status(:unprocessable_entity)
    body = JSON.parse(response.body)
    expect(body["error"]).to eq("Unknown product: XYZ")
  end

  it "requires items to be an array" do
    post "/checkout", params: { items: "GR1" }, as: :json

    expect(response).to have_http_status(:unprocessable_entity)
    body = JSON.parse(response.body)
    expect(body["error"]).to eq("items must be an array")
  end
end
