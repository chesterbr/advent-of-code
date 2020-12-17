notes = File.readlines("input.txt", chomp:true)

buses = notes[1].split(",").map(&:to_i)
remainders = buses.each_with_index.map do |bus, i|
  next if bus == 0
  (bus - i) % bus
end

def inv(a, m)
    (1..m).each{|x| break x if (a*x % m == 1)}
end

m = buses.reject(&:zero?)
a = remainders.reject(&:nil?)

puts m.inspect
puts a.inspect

M = m.reduce(:*)
b = m.map{ |mi| M / mi }
binv = b.zip(m).map { |bi, mi| inv(bi, mi) }

puts M
puts b.inspect
puts binv.inspect
x = 0.upto(a.count-1).map{ |i| a[i] * b[i] * binv[i] }.sum % M

puts x
return

# n = remainders.reject(&:nil?).max
# step = buses[remainders.find_index(n)]
# while buses.map{|bus| n % bus if bus != 0} != remainders
#   n += step
# end
# puts n
# buses_and_remainders = buses.zip(remainders)



# puts buses_and_remainders.map { |bus, remainder| }

# candidate_time = 0
# while true
#   buses.map{ |n| n % }


puts buses.inspect
puts remainders.inspect
puts buses.map{|bus| n % bus if bus != 0}.inspect
