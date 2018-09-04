require 'test_helper'

class Nectarine::Test < ActiveJob::TestCase
  
  def setup
    10.times do |i|
      Snail.create()
    end

    5.times do |i|
      Friend.create(snail_id: 1)
    end
  end

  def test_basics
    perform_enqueued_jobs do 
      Snail.limit(5).nectarine(:move)

      assert_performed_jobs 5
    end
  end

  def test_children
    perform_enqueued_jobs do 
      Snail.first.friends.nectarine(:party)

      assert_performed_jobs 5
    end
  end
end
