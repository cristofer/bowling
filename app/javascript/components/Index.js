import React from "react";
import { Provider } from "react-redux";

import { createStore, applyMiddleware } from "redux";
import { composeWithDevTools } from "redux-devtools-extension";

import { ActionCableProvider } from "react-actioncable-provider";

import createSagaMiddleware from "redux-saga";
import rootSaga from "../sagas";

import rootReducer from "../reducers";

const sagaMiddleware = createSagaMiddleware();

const store = createStore(
  rootReducer,
  composeWithDevTools(applyMiddleware(sagaMiddleware))
);

sagaMiddleware.run(rootSaga);

import Game from "./Game";
import { WEBSOCKET } from "../constants";

class Index extends React.Component {
  render() {
    return (
      <Provider store={store}>
        <ActionCableProvider url={`${WEBSOCKET}`}>
          <section className="section">
            <Game />
          </section>
        </ActionCableProvider>
      </Provider>
    );
  }
}

export default Index;
