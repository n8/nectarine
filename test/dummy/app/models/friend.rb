class Friend < ApplicationRecord

  belongs_to :snail

  def party
    sleep 1
  end
end
