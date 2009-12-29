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
        <<-"SQL"
          -- Remove Pill Phone reminders
          DELETE FROM reminder WHERE medicine_id IN (
            SELECT id FROM medicine WHERE user_id IN (
              SELECT id FROM user WHERE number LIKE '%#{phonenumber}'));
          -- Remove Pill Phone medications
          DELETE FROM medicine WHERE user_id IN (
            SELECT id FROM user WHERE number LIKE '%#{phonenumber}'));
          -- Remove Pill Phone user
          DELETE FROM user WHERE number LIKE '%#{phonenumber}'));
        SQL
      end
    end
  end
end

# pillphone.settings#sms
module Pillphone
  module Settings
    class Sms < SubscriberLogic
      def delete_subscriber( phonenumber )
        <<-"SQL"
          -- Remove number listed as an SMS contact
          UPDATE settings SET sms = NULL WHERE sms LIKE '%#{phonenumber}';
        SQL
      end
    end
  end
end
