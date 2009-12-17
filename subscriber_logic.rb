require 'class_family'

class SubscriberLogic
  extend ClassFamily
  
  def initialize( schema, table, column )
    @schema = schema
    @table = table
    @column = column
  end

  def delete_subscriber( phonenumber )
    "DELETE FROM `#{@schema}`.`#{@table}` WHERE CAST(`#{@column}` AS CHAR) LIKE '%#{phonenumber}';"
  end
end

module Alltelportal
  module Subscribers
    class Phonenumber < SubscriberLogic
      def delete_subscriber( phonenumber )
        "-- Alltel subscriber should not be DB deleted"
      end
    end
  end
end