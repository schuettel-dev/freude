class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games do |t|
      t.string :name, null: false, index: { unique: true }
      t.string :image_path, null: false
      t.string :description, null: false
      t.string :url_identifier, null: false, index: { unique: true }
      t.string :type, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
