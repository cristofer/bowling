export const createGame = name => ({
  type: "CREATE_GAME",
  name
});

export const gameCreated = (id, name) => ({
  type: "GAME_CREATED",
  id,
  name
});

export const createScore = (game_id, score) => ({
  type: "CREATE_SCORE",
  game_id,
  score
});

export const scoreCreated = score => ({
  type: "SCORE_CREATED",
  score
});

export const statusGame = game_id => ({
  type: "STATUS_GAME",
  game_id
});

export const setStatusGame = status => ({
  type: "SET_STATUS_GAME",
  status
});
