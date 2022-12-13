class CreatePlayers < ActiveRecord::Migration[7.0]
  def change
    create_table :players do |t|
      t.references :user, null: false, foreign_key: true
      t.references :game, null: false, foreign_key: true
      t.string :type, null: false

      t.index %i[game_id user_id], unique: true

      t.timestamps
    end
  end
end