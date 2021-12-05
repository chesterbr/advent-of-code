lines = File.readlines("input", chomp:true)

depths = lines.map(&:to_i)
increases = 0
depths.reduce(depths.first) do |last, depth|
  increases += 1 if last < depth
  depth
end
puts increases
