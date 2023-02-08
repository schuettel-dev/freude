class Player::Beatle::Playlist < ApplicationRecord
  self.table_name = :player_beatle_playlists

  belongs_to :player
end
