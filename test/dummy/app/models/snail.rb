class Snail < ApplicationRecord

  has_many :friends

  def move
    sleep 1
  end
end
