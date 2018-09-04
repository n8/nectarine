require "activejob-status"

class Nectarine::GoodJob < ActiveJob::Base
  include ActiveJob::Status

  def perform(object, method)
    object.try(method)
  end
end