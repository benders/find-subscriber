#!/usr/bin/env ruby -wKU

require 'rubygems'
require 'mysql'

HOSTNAME= ""
USERNAME= "finder"
PASSWORD= "E7RSG9eYTwMpDsLS"

$db = Mysql.new(HOSTNAME, USERNAME, PASSWORD)

search_number = ARGV[0]

products = []
File.open("table-list.txt") do |file|
  file.each do |line|
    table_name, field_name = line.split('#')
    product = table_name.split(/\W+/).first

    begin
      st = $db.prepare("SELECT * FROM #{table_name} WHERE CAST(#{field_name} AS CHAR) LIKE ?;")
      st.execute("%#{search_number}")
    rescue Mysql::Error => e
      STDERR.puts "ERROR on #{line.chomp}: #{e.to_s}"
      next
    end

    if st.num_rows > 0
      products << product unless products.include?(product)
      STDERR.puts "FOUND in #{table_name}#{field_name}"
    end
  end
end

puts
if products.any?
  puts "Subscriber #{search_number} found in #{products.join(', ')} products"
  exit(0)
else
  puts "Subscriber #{search_number} NOT FOUND in any products"
  exit(1)
end

$db.close