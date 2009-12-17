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

# alltelportal_prod.subscribers#phonenumber
module AlltelportalProd
  module Subscribers
    class Phonenumber < SubscriberLogic
      def delete_subscriber( phonenumber )
        "-- Alltel subscriber should not be DB deleted"
      end
    end
  end
end

# alltelvmg_prod.subscribers#phonenumber
module AlltelvmgProd
  module Subscribers
    class Phonenumber < SubscriberLogic
      def delete_subscriber( phonenumber )
        "-- Alltel VMG subscriber should not be DB deleted"
      end
    end
  end
end

# pillphone.user#number
module Pillphone
  module User
    class Number < SubscriberLogic
      def delete_subscriber( phonenumber )
        "-- Pillphone subscriber should not be DB deleted"
      end
    end
  end
end

# pillphone.settings#sms
module Pillphone
  module Settings
    class Sms < SubscriberLogic
      def delete_subscriber( phonenumber )
        "-- Pillphone subscriber should not be DB deleted"
      end
    end
  end
end
