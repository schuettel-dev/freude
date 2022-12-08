class CreateGameInstances < ActiveRecord::Migration[7.0]
  def change
    create_table :game_instances do |t|
      t.string :group_name, null: false
      t.references :game, null: false, foreign_key: true, index: true
      t.references :user, null: false, foreign_key: true, index: true
      t.string :state, null: false
      t.string :type, null: false
      t.string :token, null: false

      t.timestamps
    end
  end
end
