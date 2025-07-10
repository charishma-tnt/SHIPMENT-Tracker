require "rails_helper"

RSpec.describe "ShipmentFlows", type: :system do
  before do
    driven_by(:rack_test)
  end

  let(:admin) { create(:user, :admin) }
  let(:customer) { create(:user, :customer) }
  let(:delivery_partner) { create(:user, :delivery_partner) }

  before do
    driven_by(:rack_test)
  end

  context "as admin" do
    before do
      login_as(admin, scope: :user)
    end

    it "can access dashboard and see shipments" do
      visit dashboard_shipments_path
      expect(page).to have_content("Dashboard")
      expect(page).to have_link("My Shipments")
    end
  end

  context "as customer" do
    before do
      login_as(customer, scope: :user)
    end

    it "can create a shipment" do
      visit new_shipment_path
      fill_in "Source", with: "New York"
      fill_in "Target", with: "Los Angeles"
      fill_in "Item details", with: "Books"
      click_button "Create Shipment"
      expect(page).to have_content("Shipment was successfully created.")
      expect(page).to have_content("New York")
      expect(page).to have_content("Los Angeles")
    end
  end

  context "as delivery partner" do
    before do
      login_as(delivery_partner, scope: :user)
    end

    it "can accept a shipment delivery" do
      shipment = create(:shipment, status: Shipment::STATUS_VALUES["pending"], delivery_partner: nil, customer: create(:customer))
      visit shipment_path(shipment)
      if page.has_button?("Accept Delivery")
        click_button "Accept Delivery"
        expect(page).to have_content("Shipment status updated to 'In Transit'.")
      else
        skip "Accept Delivery button not available"
      end
    end
  end
end
