import React from 'react';
import { render } from '@testing-library/react';
import FreeSlots from './free_slots';

describe('when rendering', () => {
  it('loads the available slots from the api');
  describe('when loaded', () => {
    it('shows the list of the available slots');
    describe('when reserving a slot', () => {
      it('shows a confirmation dialog');
      it('calls the api to reserve the slot');
    });
  });

  describe('when received reservations changed event', () => {
    it('fetches again the available slots');
  });
});
