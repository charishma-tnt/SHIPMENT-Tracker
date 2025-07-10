import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // Add any interactive behavior if needed
    // For now, just log connection
    console.log("ShipmentStatsController connected")
  }
}
