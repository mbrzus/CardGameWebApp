class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      # Foreign Key relationship
      t.references   "room"
      t.string   "value"
      t.string   "suit"
      t.string "image_url"
      # Foreign Key relationship
      t.references "player"
      # Though we won't probably have a use for these fields, it doesn't hurt to keep them
      t.timestamps
    end
  end
end
