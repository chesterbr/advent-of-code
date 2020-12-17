adaptors = File.readlines("input.txt", chomp:true).map(&:to_i)

adaptors.sort!
adaptors.unshift(0)
adaptors.push(adaptors.last + 3)
puts adaptors.inspect

counts = {}
0.upto(adaptors.count - 2) do |i|
  difference = adaptors[i+1] - adaptors[i]
  counts[difference] ||= 0
  counts[difference] += 1
end
# puts counts.inspect

differences = {}
differences[0] = 3
1.upto(adaptors.count - 1) do |i|
  differences[i] = adaptors[i] - adaptors[i-1]
end
puts differences.values.inspect

paths = {}
paths[-1] = 1
paths[-2] = 1
paths[0] = 1
paths[1] = 1
2.upto(adaptors.count - 1) do |i|
  if differences[i] == 3
    paths[i] = paths[i-1]

  elsif differences[i-1] == 3
    paths[i] = paths[i-2]

  elsif differences[i-2] == 3
    paths[i] = paths[i-3] * 2

  elsif differences[i-3] == 3
    paths[i] = paths[i-4] * 4

  elsif differences[i-4] == 3
    paths[i] = paths[i-5] * 7

  else
    paths[i] = paths[i-1]
  end
end
puts paths.values.inspect
