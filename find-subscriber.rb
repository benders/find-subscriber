#!/usr/bin/env ruby -wKU

require 'rubygems'
require 'mysql'

HOSTNAME= ""
USERNAME= "finder"
PASSWORD= "E7RSG9eYTwMpDsLS"

$db = Mysql.new(HOSTNAME, USERNAME, PASSWORD)

search_number = "2495155889"

products = []
File.open("test-list.txt") do |file|
  file.each do |line|
    table_name, field_name = line.split('#')
    product = table_name.split(/\W+/).first

    st = $db.prepare("SELECT * FROM #{table_name} WHERE CAST(#{field_name} AS CHAR) LIKE ?;")
    st.execute("%#{search_number}")

    if st.num_rows > 0
      products << product unless products.include?(product)
      puts "FOUND in #{table_name}#{field_name}"
    end
  end
end

puts
puts "Subscriber found in #{products.join(', ')} products" if products.any?

$db.close