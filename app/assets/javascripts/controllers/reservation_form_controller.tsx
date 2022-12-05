import React from 'react';
import { Controller } from '@hotwired/stimulus';
import { createRoot } from 'react-dom/client';
import Form from '../components/reservations/form';

export default class extends Controller {
  declare element: HTMLElement;

  connect() {
    const root = createRoot(this.element);
    root.render(<Form />);
  }
}
