import React from "react";

class Scores extends React.PureComponent {
  render() {
    const { total, finished, frames } = this.props.statusGame;

    if (frames === undefined) return <div>No Scores</div>;

    let frames_to_return = Object.keys(frames).map(frame_key => {
      let frame = frames[frame_key];

      let first_roll = frame.first_roll < 0 ? 0 : frame.first_roll;
      let second_roll = frame.second_roll < 0 ? 0 : frame.second_roll;
      let total_frame = frame.total < 0 ? 0 : frame.total;

      return (
        <tr key={frame_key}>
          <td>
            <table className="table">
              <thead>
                <tr>
                  <td>Frame: {frame.number}</td>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td>{first_roll}</td>
                  <td>{second_roll}</td>
                </tr>
                <tr>
                  <td>{total_frame}</td>
                </tr>
              </tbody>
            </table>
          </td>
        </tr>
      );
    });

    return (
      <table className="table">
        <thead>
          <tr>
            <td>Total: {total}</td>
          </tr>
        </thead>
        <tbody>{frames_to_return}</tbody>
      </table>
    );
  }
}

export default Scores;
