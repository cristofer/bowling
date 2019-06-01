import React from "react";
import { Provider } from "react-redux";

import { createStore, applyMiddleware } from "redux";
import { composeWithDevTools } from "redux-devtools-extension";

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

class Index extends React.Component {
  render() {
    return (
      <Provider store={store}>
        <section className="section">
          <Game />
        </section>
      </Provider>
    );
  }
}

export default Index;
