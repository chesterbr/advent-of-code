input = File.readlines("input", chomp:true)

lines = input.map { |line| line.scan(/\d+/).map(&:to_i) }

sea = {}

lines.each do |x1, y1, x2, y2|
  if x1 == x2
    [y1,y2].min.upto([y1,y2].max) do |y|
      sea[[y,x1]] ||= 0
      sea[[y,x1]] += 1
    end
  elsif y1 == y2
    [x1,x2].min.upto([x1,x2].max) do |x|
      sea[[y1,x]] ||= 0
      sea[[y1,x]] += 1
    end
  end
end

puts sea.count { |_,v| v > 1 }
