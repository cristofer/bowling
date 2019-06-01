const game = (state = {}, action) => {
  switch (action.type) {
    case "GAME_CREATED":
      return {
        ...state,
        id: action.id,
        name: action.name
      };
    default:
      return state;
  }
};

export default game;
