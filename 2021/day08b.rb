input = File.readlines("input", chomp:true)

sum = 0
input.each do |line|
  signal = line.split("|").first.split(" ").map { |v| v.split("").sort.join }
  output = line.split("|").last.split(" ").map { |v| v.split("").sort.join }

  patterns = (signal + output).uniq

  # These come from length, like in part 1
  dict = {}
  dict[1] = patterns.find { |v| v.length == 2 }
  dict[7] = patterns.find { |v| v.length == 3 }
  dict[4] = patterns.find { |v| v.length == 4 }
  dict[8] = patterns.find { |v| v.length == 7 }

  # Let's group the remaining patterns by length
  patterns_069 = patterns.filter { |v| v.length == 6 }
  patterns_235 = patterns.filter { |v| v.length == 5 }

  # dict[1] contains segments c and f, which allow deducing these digits:
  c_and_f = dict[1].split("")
  dict[3] = patterns_235.find { |v| v.include?(c_and_f[0]) && v.include?(c_and_f[1]) }
  dict[6] = patterns_069.reject { |v| v.include?(c_and_f[0]) && v.include?(c_and_f[1]) }.first

  # That reduces the groups a bit
  patterns_09 = patterns_069 - [dict[6]]
  patterns_25 = patterns_235 - [dict[3]]

  # dict[4] contains segments b and d (in addition to dict[1]'s c and f), allowing further disambiguation:
  b_and_d = dict[4].split("") - c_and_f
  dict[5] = patterns_25.find { |v| v.include?(b_and_d[0]) && v.include?(b_and_d[1]) }
  dict[9] = patterns_09.find { |v| v.include?(b_and_d[0]) && v.include?(b_and_d[1]) }
  dict[2] = (patterns_25 - [dict[5]]).first
  dict[0] = (patterns_09 - [dict[9]]).first

  digit_for_pattern = dict.invert
  output_value = output.map { |v| digit_for_pattern[v] }.join.to_i

  sum += output_value
end

puts sum
