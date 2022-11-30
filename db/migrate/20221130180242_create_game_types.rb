class CreateGameTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :game_types do |t|
      t.string :name, null: false, index: { unique: true }
      t.string :description, null: false
      t.string :instance_type, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
