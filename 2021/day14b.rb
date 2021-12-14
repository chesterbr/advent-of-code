input = File.readlines("input", chomp:true)

template = input.first

rules = {}
input.drop(2).each do |line|
  pair, inserted = line.split(" -> ")
  rules[pair] = [pair[0] + inserted, inserted + pair[1]]
end

pair_frequency = Hash.new(0)
0.upto(template.length - 2) do |i|
  pair_frequency[template[i..i+1]] += 1
end

1.upto(40) do |step|
  changes = Hash.new(0)
  pair_frequency.each do |pair, count|
    changes[pair] -= count
    changes[rules[pair][0]] += count
    changes[rules[pair][1]] += count
  end
  pair_frequency.merge!(changes) { |_, value, delta| value + delta }
  pair_frequency.delete_if { |_, count| count == 0 }
end

frequencies = Hash.new(0)
pair_frequency.each do |pair, count|
  pair.chars.each do |char|
    frequencies[char] += count
  end
end
frequencies.transform_values! { |count| (count / 2.0).ceil }
puts frequencies.values.max - frequencies.values.min

return

