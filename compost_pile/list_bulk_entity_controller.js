import { Controller } from "@hotwired/stimulus"
import ListBulkEntityAdder from '../src/components/list_bulk_entity_adder'

export default class extends Controller {
  static values = { resourceId: Number }

  connect() {
    ListBulkEntityAdder().init({
      domId: "bulk-add-container",
      resourceId: this.resourceIdValue,
      resourceType: "lists"
    })
  }
}
