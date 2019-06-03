import { put, takeEvery, all, call, select } from "redux-saga/effects";
import axios from "axios";

import {
  gameCreated,
  scoreCreated,
  setStatusGame,
  statusGame
} from "../actions";
import { API_BASE_URL } from "../constants";

/* API */

// /api/v1/games/create
function createGameApi(name) {
  const data = { name: name };

  return axios.request({
    method: "post",
    url: `${API_BASE_URL}/create`,
    data: data
  });
}

// /api/v1/games/:game_id/scores/create
function createScoreApi(game_id, score) {
  const data = { score: score };

  return axios.request({
    method: "post",
    url: `${API_BASE_URL}/${game_id}/scores/create`,
    data: data
  });
}

// /api/v1/games/:game_id/status
function getStatusApi(game_id) {
  return axios.request({
    method: "get",
    url: `${API_BASE_URL}/${game_id}/status`
  });
}

/* Sagas workers */

function* createGameWorker({ name }) {
  try {
    const { data } = yield call(createGameApi, name);

    yield put(gameCreated(data.data.id, data.data.attributes.name));
    yield put(statusGame(data.data.id));
  } catch (e) {
    console.log("Error in createGameWorker");
    console.log(e);
  }
}

function* createScoreWorker({ game_id, score }) {
  try {
    const { data } = yield call(createScoreApi, game_id, score);

    yield put(scoreCreated(data.data));
  } catch (e) {
    console.log("Error in createScoreWorker");
    console.log(e);
  }
}

function* getGameStatusWorker({ game_id }) {
  try {
    if (game_id === undefined) return;

    const { data } = yield call(getStatusApi, game_id);

    yield put(setStatusGame(data.data));
  } catch (e) {
    console.log("Error in getGameStatusWorker");
    console.log(e);
  }
}

/* Watchers */

export function* watchCreateGame() {
  yield takeEvery("CREATE_GAME", createGameWorker);
}

export function* watchCreateScore() {
  yield takeEvery("CREATE_SCORE", createScoreWorker);
}

export function* watchStatusGame() {
  yield takeEvery("STATUS_GAME", getGameStatusWorker);
}

export default function* rootSaga() {
  yield all([watchCreateGame(), watchCreateScore(), watchStatusGame()]);
}
