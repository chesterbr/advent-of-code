require "set"

lines = File.readlines("input.txt", chomp:true)
lines << ""

# For each bag, lists WHAT THEY CAN CONTAIN
bags = {}

lines.each do |line|
  next if line.strip == ""
  bag, contents = line.split(" bags contain")
  contents = contents.split(",")
  contents.each do |content|
    content = content.chomp(".").chomp("bags").chomp("bag").strip
    quantity, color = content.split(' ', 2)
    unless content == "no other"
      bags[bag] ||= []
      bags[bag] << [quantity.to_i, color]
    end
  end
end

def contents_for(color, bags, multiplier = 1)
  result = []
  bags[color]&.each do |contents|
    quantity, color = contents
    result << (contents + [multiplier])
    result += (contents_for(color, bags, multiplier*quantity))
    # count += 1 + count(bag, bags.filter{|k,v| k != color})
  end
  result
end

puts bags.inspect
c =  contents_for("shiny gold", bags)
puts c.inspect
total = 0
c.each do |quantity, color, multiplier|
  total += quantity*multiplier
end
puts total


