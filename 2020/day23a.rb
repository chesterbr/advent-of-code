input = File.readlines("input", chomp:true)

cups = input.first.split("").map(&:to_i)
current = cups.first
highest = cups.max

1.upto(100) do |move|
  puts
  puts "-- move #{move} --"
  puts cups.inspect.gsub(current.to_s, "(#{current})")
  pick_up = []
  pick_up_index = cups.index(current) + 1
  3.times do
    pick_up_index = 0 if pick_up_index > cups.count - 1
    pick_up << cups[pick_up_index]
    cups.delete_at(pick_up_index)
  end
  puts pick_up.inspect
  destination = current - 1
  destination = highest if destination == 0
  while pick_up.any?(destination) do
    destination -= 1
    destination = highest if destination == 0
  end
  puts destination
  position = cups.index(destination) + 1
  while pick_up.any? do
    cups.insert(position, pick_up.pop)
  end
  current = cups[cups.index(current) + 1] || cups.first
end

puts
puts "-- final --"
puts cups.inspect.gsub(current.to_s, "(#{current})")

puts "part 1:"
puts (cups[(cups.index(1) + 1)..] + cups[0..cups.index(1) - 1]).join
