class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      # We will need the concept of different decks since we have decided to allow multiple
      # different "rooms" to play within.
      t.integer   "room_id"
      t.string   "value"
      t.string   "suit"
      t.string "image_url"
      # Though we won't probably have a use for these fields, it doesn't hurt to keep them
      t.timestamps
    end
  end
end
