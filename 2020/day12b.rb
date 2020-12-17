instructions = File.readlines("input.txt", chomp:true)

def rotate(x, y, angle_degrees)
  angle = angle_degrees * Math::PI / 180
  [
    x * Math.cos(angle) - y * Math.sin(angle),
    x * Math.sin(angle) + y * Math.cos(angle)
  ].map(&:round)
end

pos_east = 0
pos_north = 0
waypoint_east = 10
waypoint_north = 1
instructions.each do |instruction|
  action = instruction[0]
  value = instruction[1..].to_i
  case action
  when "N"
    waypoint_north += value
  when "S"
    waypoint_north -= value
  when "E"
    waypoint_east += value
  when "W"
    waypoint_east -= value
  when "L"
    waypoint_east, waypoint_north = rotate(waypoint_east, waypoint_north, value)
  when "R"
    waypoint_east, waypoint_north = rotate(waypoint_east, waypoint_north, -value)
  when "F"
    pos_east += waypoint_east * value
    pos_north += waypoint_north * value
  end


  puts instruction
  puts "east: #{pos_east} north: #{pos_north} waypoint_east: #{waypoint_east} waypoint_north: #{waypoint_north} "

end

puts pos_east.abs + pos_north.abs

