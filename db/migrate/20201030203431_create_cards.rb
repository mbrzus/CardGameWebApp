class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      # We will need the concept of different decks since we have decided to allow multiple
      # different "rooms" to play within.
      t.integer   "deck_number"
      t.string   "value"
      t.string   "suit"
      # This field can be used to track who currently posses the card
      # Ex. "Jacob", "sink1", "source2", "none"
      t.string   "owned_by"
      # Though we won't probably have a use for these fields, it doesn't hurt to keep them
      t.timestamps
    end
  end
end
