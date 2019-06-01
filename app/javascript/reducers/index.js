import { combineReducers } from "redux";

import game from "./game";
import scores from "./scores";
import status_game from "./status_game";

export default combineReducers({
  game,
  scores,
  status_game
});
