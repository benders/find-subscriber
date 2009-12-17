#!/usr/bin/env ruby

require 'rubygems'
require 'mysql'

require 'subscriber_logic'

HOSTNAME= ""
USERNAME= "finder"
PASSWORD= "E7RSG9eYTwMpDsLS"

$db = Mysql.new(HOSTNAME, USERNAME, PASSWORD)

search_number = ARGV[0].chomp
unless search_number && search_number.match(/^[0-9]{10,}$/)
  STDERR.puts "Usage: #{$0} <phonenumber>"
  exit(-1)
end

products = []
File.open("table-list.txt") do |file|
  file.each do |line|
    table_name, field_name = line.chomp.split('#')
    schema, table = table_name.split('.')

    begin
      st = $db.prepare("SELECT * FROM #{table_name} WHERE CAST(#{field_name} AS CHAR) LIKE ?;")
      st.execute("%#{search_number}")
    rescue Mysql::Error => e
      STDERR.puts "ERROR on #{line.chomp}: #{e.to_s}"
      next
    end

    if st.num_rows > 0
      STDERR.puts "FOUND in #{table_name}##{field_name}"
      products << schema unless products.include?(schema)
      x = SubscriberLogic.new(schema, table, field_name)
      puts x.delete_subscriber( search_number )
    end
  end
end

puts
if products.any?
  puts "Subscriber #{search_number} found in #{products.join(', ')}"
  exit(0)
else
  puts "Subscriber #{search_number} NOT FOUND in any products"
  exit(1)
end

$db.close
