import React from 'react';
import FreeSlots from './free_slots';

const Form = () => {
  const dateRef = React.createRef();
  const durationRef = React.createRef();
  const [filterData, setFilterData] = React.useState();
  const onFilter = (e) => {
    setFilterData({ date: dateRef.current.value, duration: durationRef.current.value });
    /// reservations/free_slots
    e.preventDefault();
  };

  return (
    <form onSubmit={onFilter}>
      <div className="row align-items-end gx-0">
        <div className="col-4">
          <label htmlFor="date">Date</label>
          <input type="date" name="date" defaultValue="2022-12-04" className="form-control"
                 required="required" ref={dateRef} />
        </div>
        <div className="col-4">
          <label htmlFor="duration">Duration</label>
          <input type="number" name="duration" defaultValue="30" className="form-control"
                 required="required" step="15" min="15" ref={durationRef} />
        </div>
        <div className="col">
          <button name="button" type="submit" className="btn btn-primary">Filter free slots</button>
        </div>
      </div>
      { filterData && <FreeSlots { ...filterData } /> }
    </form>
  );
};
export default Form;
