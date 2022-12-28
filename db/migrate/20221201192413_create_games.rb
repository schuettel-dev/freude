class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games do |t|
      t.string :group_name, null: false
      t.references :game_template, null: false, foreign_key: true, index: true
      t.references :user, null: false, foreign_key: true, index: true
      t.string :phase, null: false
      t.string :type, null: false
      t.string :url_identifier, null: false, index: { unique: true }
      t.string :join_token, null: false

      t.timestamps
    end
  end
end
