import React from "react";

import { createGame, createScore, statusGame } from "../actions";

import { connect } from "react-redux";

import Scores from "./Scores";

import { ActionCableConsumer } from "react-actioncable-provider";

class Game extends React.PureComponent {
  componentDidMount() {
    this.setState({ gameName: "" });
  }

  handleStatusGame = response => {
    this.props.statusGame(this.props.game.id);
  };

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

  renderActionCable = () => {
    if (this.acc && this.props.game.id == this.gameId) {
      return this.acc;
    } else {
      this.acc = (
        <ActionCableConsumer
          channel={{ channel: "GamesChannel", game_id: this.props.game.id }}
          onReceived={this.handleStatusGame}
        />
      );
      this.gameId = this.props.game.id;
      return this.acc;
    }
  };

  render() {
    return (
      <React.Fragment>
        {this.renderActionCable()}
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
              <Scores
                statusGame={this.props.status_game}
                handleStatusGame={this.handleStatusGame}
                gameId={this.props.game.id}
              />
            </div>
          </div>
        </div>
      </React.Fragment>
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
