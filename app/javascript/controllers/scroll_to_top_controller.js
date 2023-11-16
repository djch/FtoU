// scroll_to_top_controller.js
import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  jump() {
    window.scrollTo(0, 0);
  }
}
