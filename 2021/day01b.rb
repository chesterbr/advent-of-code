lines = File.readlines("input", chomp:true)

depths = lines.map(&:to_i)
starting_window = depths.slice!(0,3)
increases = 0
depths.reduce(starting_window) do |window, depth|
  last_sum = window.sum
  window.shift
  window.push(depth)
  sum = window.sum
  increases += 1 if last_sum < sum
  window
end
puts increases
