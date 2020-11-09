class Card < ActiveRecord::Base
  @room_id
  @value
  @suit

  def suits
    %w[diamonds clubs spades hearts]
  end

  def values
    %w[A 1 2 3 4 5 6 7 8 9 10 J Q K]
  end

end
