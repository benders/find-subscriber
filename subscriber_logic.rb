require 'class_family'

class SubscriberLogic
  extend ClassFamily

  def ping
    "."
  end
end

module Alltelportal
  module Subscribers
    class Phonenumber < SubscriberLogic
      def ping
        "PONG"
      end
    end
  end
end