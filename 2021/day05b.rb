input = File.readlines("input", chomp:true)

lines = input.map { |line| line.scan(/\d+/).map(&:to_i) }

sea = {}

lines.each do |x1, y1, x2, y2|
  x = x1
  y = y1
  loop do
    sea[[y,x]] ||= 0
    sea[[y,x]] += 1
    break if x == x2 && y == y2
    x += (x2 > x1 ? 1 : -1) unless x1 == x2
    y += (y2 > y1 ? 1 : -1) unless y1 == y2
  end
end

puts sea.count { |_,v| v > 1 }
