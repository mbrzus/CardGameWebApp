class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :name
      t.belongs_to :room
      t.text :description
      t.datetime :release_date
      t.timestamps
    end
  end
end
