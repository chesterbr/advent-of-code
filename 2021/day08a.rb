input = File.readlines("input", chomp:true)

times_1478 = 0
input.each do |line|
  output_values = line.split("|").last.split(" ")
  times_1478 += output_values.count { |value| [2, 3, 4, 7].include? value.length  }
end

puts times_1478
