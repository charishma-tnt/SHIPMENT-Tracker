import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["roleSection", "trackingSection"]

  showTracking() {
    this.roleSectionTarget.classList.add("hidden")
    this.trackingSectionTarget.classList.remove("hidden")
  }

  showRoles() {
    this.roleSectionTarget.classList.remove("hidden")
    this.trackingSectionTarget.classList.add("hidden")
  }
}
