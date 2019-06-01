const scores = (state = [], action) => {
  switch (action.type) {
    case "SCORE_CREATED":
      return [...state, action.score];
    default:
      return state;
  }
};

export default scores;
