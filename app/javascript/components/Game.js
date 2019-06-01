import React from "react";

import { createGame, createScore, statusGame } from "../actions";

import { connect } from "react-redux";

import Scores from "./Scores";

class Game extends React.PureComponent {
  componentDidMount() {
    const intervalId = setInterval(() => {
      this.props.statusGame(this.props.game.id);
    }, 2000);

    this.setState({ intervalId: intervalId, gameName: "" });
  }

  componentWillUnmount() {
    clearInterval(this.state.intervalId);
  }

  handleChangeText = evt => {
    this.setState({
      gameName: evt.target.value
    });
  };

  parseText = () => {
    if (this.state.gameName == "") return;

    this.props.createGame(this.state.gameName);
  };

  onKeyDown = event => {
    if (event.keyCode == 13) {
      this.parseText();
    }
  };

  render() {
    return (
      <div className="container">
        <div className="columns">
          <div className="column is-12">
            <div className="box">
              <h1 className="title">Welcome to Free-Bowling!</h1>
              <h4 className="subtitle">
                <a href="apidoc/index.html" target="_blank">
                  API Documentation
                </a>
              </h4>
              <h4>
                Add a new Game, and with the ID you can start{" "}
                <a
                  href="apidoc/index.html#path--api-v1-games--game_id--scores-create"
                  target="_blank"
                >
                  adding Scores
                </a>{" "}
                using the API interface
              </h4>
            </div>
          </div>
        </div>

        <div className="columns">
          <div className="column">
            <div className="field">
              <label className="label">
                Create a new Game ({this.props.game.id})
              </label>
              <div className="control">
                <input
                  className="input"
                  type="text"
                  placeholder="Name of the Game (press enter)"
                  onChange={this.handleChangeText}
                  onKeyDown={this.onKeyDown}
                />
              </div>
            </div>
          </div>

          <div className="column">
            <Scores statusGame={this.props.status_game} />
          </div>
        </div>
      </div>
    );
  }
}

const mapStateToProps = state => {
  return {
    game: state.game,
    status_game: state.status_game
  };
};

const mapDispatchToProps = dispatch => {
  return {
    createGame: name => dispatch(createGame(name)),
    statusGame: game_id => dispatch(statusGame(game_id))
  };
};

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(Game);
