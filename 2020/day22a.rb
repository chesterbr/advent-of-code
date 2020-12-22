input = File.readlines("input", chomp:true)

pos = input.index("")
deck1 = input[1..pos - 1].map(&:to_i)
deck2 = input[pos + 2..].map(&:to_i)

while deck1.any? && deck2.any?
  c1, c2 = deck1.shift, deck2.shift
  if c1 > c2
    deck1.push c1, c2
  else
    deck2.push c2, c1
  end
end

deck = deck1.any? ? deck1 : deck2
puts deck.count.downto(1).to_a.zip(deck).map{|i,j| i*j }.inject(:+)

puts deck1.inspect
puts deck2.inspect
