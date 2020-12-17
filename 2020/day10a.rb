adaptors = File.readlines("input.txt", chomp:true).map(&:to_i)

adaptors.sort!
adaptors.unshift(0)
adaptors.push(adaptors.last + 3)

difference = []
0.upto(adaptors.count - 2) do |i|
  difference[i] = adaptors[i+1] - adaptors[i]
end
puts difference.inspect

