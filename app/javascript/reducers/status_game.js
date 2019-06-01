const status_game = (state = {}, action) => {
  switch (action.type) {
    case "SET_STATUS_GAME":
      return { ...action.status };
    default:
      return state;
  }
};

export default status_game;
