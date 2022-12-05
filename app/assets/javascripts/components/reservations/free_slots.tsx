import React from 'react';
import { post } from '@rails/request.js';
import consumer from '../../channels/consumer';

const subscribeToChannel = (date:string, callback: () => void) => {
  const channel = consumer.subscriptions.create({ channel: 'FreeSlotsChannel', date }, {
    received(data) {
      console.log('changed reservations on date:', data);
      callback();
    },
  });
  return channel;
};

const dateLabel = (date: string) => new Date(Date.parse(date)).toLocaleTimeString('default', {
  hour: '2-digit',
  minute: '2-digit',
});

const FreeSlots = ({ date, duration }) => {
  const [slots, setSlots] = React.useState(null);
  const fetchData = () => {
    fetch(`/reservations/free_slots.json?date=${date}&duration=${duration}`)
      .then((response) => response.json())
      .then((res) => setSlots(res));
  };

  const doReservation = async (startAt: string) => {
    const response = await post(`/reservations?duration=${duration}&start_at=${startAt}`, { responseKind: 'turbo-stream' });
    if (response.ok) Turbo.visit('/reservations');
  };

  React.useEffect(() => {
    fetchData();
  }, [date, duration]);

  React.useEffect(() => {
    const channel = subscribeToChannel(date, fetchData);
    return () => { channel.unsubscribe(); };
  }, [date]);

  return (
    <div className='mt-3'>
      { slots
        && <>
          <h2>Available Slots</h2>
          <table className='table table-striped'>
            <tbody>
            { slots.map((slot) => <tr key={slot[0]}>
                <td>{dateLabel(slot[0])}</td>
                <td className='text-end'>
                  <button className="btn btn-primary btn-sm" onClick={() => doReservation(slot[0])}
                          data-confirm="Are you sure you want reserve this slot 04 Dec 08:00?"
                          data-controller="confirm" type="submit">Reserve
                  </button>
                </td>
              </tr>)}
            </tbody>
          </table>
        </>
      }
    </div>
  );
};

export default FreeSlots;
