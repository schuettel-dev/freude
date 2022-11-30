class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :token, null: false
      t.string :color, null: true

      t.index [:token], unique: true

      t.timestamps
    end
  end
end
