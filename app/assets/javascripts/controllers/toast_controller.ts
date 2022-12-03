import { Toast } from 'bootstrap';
import { Controller } from '@hotwired/stimulus';

// Sample: <div data-controller="toast" class="bg-danger">My message</div>
export default class extends Controller {
  declare element: HTMLElement;

  connect() {
    if (this.wasAlreadyParsed()) return;

    this.parseContent();
    const toast = new Toast(this.element, {});
    toast.show();
  }

  parseContent() {
    const btn = '<button aria-label="Close" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" type="button"></button>';
    const html = `<div class="d-flex">
                    <div class="toast-body">
                    ${this.element.innerHTML}
                    </div>
                    ${btn}
                  </div>`;
    this.element.innerHTML = html;
    const classes = 'toast align-items-center text-white border-0'.split(' ');
    this.element.classList.add(...classes);
  }

  // control when browser goes backward
  wasAlreadyParsed() {
    const attrName = 'data-parsed';
    const parsed = this.element.getAttribute(attrName);
    if (!parsed) this.element.setAttribute(attrName, 'true');
    return !!parsed;
  }
}
