import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="report"
export default class extends Controller {
  connect() {
    console.log("funcionando")
  }
  greet() {
    console.log("funcionando")
  }
}
