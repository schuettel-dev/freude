class CreateGameTemplates < ActiveRecord::Migration[7.0]
  def change
    create_table :game_templates do |t|
      t.string :name, null: false, index: { unique: true }
      t.string :description, null: false
      t.integer :minimum_players, null: false
      t.integer :free_players, null: false
      t.integer :maximum_players, null: false
      t.string :url_identifier, null: false, index: { unique: true }
      t.string :namespace, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
