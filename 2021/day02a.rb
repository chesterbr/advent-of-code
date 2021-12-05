lines = File.readlines("input", chomp:true)

horizontal_position, depth = 0, 0
lines.map(&:split).each do |direction, units|
  case direction
  when "up"
    depth -= units.to_i
  when "down"
    depth += units.to_i
  when "forward"
    horizontal_position += units.to_i
  end
end

puts horizontal_position, depth, horizontal_position * depth
