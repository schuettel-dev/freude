class CreateGamesBeatlePlaylistGuesses < ActiveRecord::Migration[7.0]
  def change
    create_table :games_beatle_playlist_guesses do |t|
      t.references :player
      t.references :guessing_player, null: false, foreign_key: { to_table: :players }
      t.references :guessed_player, null: true, foreign_key: { to_table: :players }
      t.integer :points, null: false, default: 0

      t.index [:player_id, :guessing_player_id], unique: true, name: :indx_player_guessing_player

      t.timestamps
    end
  end
end
