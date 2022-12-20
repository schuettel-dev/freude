class Game::Beatle < Game
  enum state: {
    collecting: "collecting",
    guessing: "guessing",
    ended: "ended"
  }
end
