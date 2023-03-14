class Player::Beatle < Player
  has_one :playlist,
          class_name: "Player::Beatle::Playlist",
          foreign_key: :player_id,
          dependent: :destroy,
          inverse_of: :player
end
