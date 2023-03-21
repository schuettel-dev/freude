class CreateGamesBeatlePlaylists < ActiveRecord::Migration[7.0]
  def change
    create_table :games_beatle_playlists do |t|
      t.references :player, null: false, index: { unique: true }, foreign_key: true
      t.string :song_1_url, null: true
      t.string :song_2_url, null: true
      t.string :song_3_url, null: true

      t.timestamps
    end
  end
end
