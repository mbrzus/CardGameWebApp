class Card < ActiveRecord::Base
  belongs_to :room
  @value
  @suit
  @image_url
  belongs_to :player
  
  # Helper function that will is called by methods in CardController that are used for card transactions
  def change_owner(new_owner_id)
    debugger
    this.player_id = new_owner_id
    # Save the changes to the card to the database
    this.save!
    debugger
  end
  
  
end
