numbers = File.readlines(ARGV[0]).map(&:to_i).sort
p1 = 0
p2 = numbers.size - 1
while (numbers[p1]+numbers[p2]!=2020)
  puts "p1: #{p1}, p2: #{p2}, #{numbers[p1]}+#{numbers[p2]}=#{numbers[p1]+numbers[p2]}"
  if numbers[p1] + numbers[p2] < 2020
    p1 += 1
  else
    p1 -= 1
    p2 -= 1
  end
end
puts "p1: #{p1}, p2: #{p2}, #{numbers[p1]}+#{numbers[p2]}=#{numbers[p1]+numbers[p2]}"
puts numbers[p1]*numbers[p2]
