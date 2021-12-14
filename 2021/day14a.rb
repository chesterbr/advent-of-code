input = File.readlines("input", chomp:true)

template = input.first
puts "Template: #{template}"

rules = {}
input.drop(2).each do |line|
  pair, inserted = line.split(" -> ")
  rules[pair] = pair[0] + inserted
end

1.upto(10) do |step|
  new_template = []
  0.upto(template.length - 1) do |i|
    new_template[i] = rules[template[i..i+1]] || template[i]
  end
  template = new_template.join
  puts "After step #{step}: #{template}"
end

frequencies = template.split("").group_by { |element| element }.map { |k, v| [k, v.length] }.to_h
puts frequencies.values.max - frequencies.values.min
