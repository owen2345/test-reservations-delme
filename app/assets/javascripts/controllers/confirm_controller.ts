import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  declare element: HTMLFormElement|HTMLElement;

  connect() {
    const action = this.element.tagName === 'FORM' ? 'submit' : 'click';
    this.element.addEventListener(action, this.confirm.bind(this), false);
  }

  confirm(event) {
    if (!(window.confirm(this.element.dataset.confirm))) {
      event.preventDefault();
      event.stopImmediatePropagation();
    }
  }
}
