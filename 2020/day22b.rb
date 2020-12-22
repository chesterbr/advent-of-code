require "set"
input = File.readlines("input", chomp:true)

pos = input.index("")
deck1 = input[1..pos - 1].map(&:to_i)
deck2 = input[pos + 2..].map(&:to_i)

# true if deck1 wins, false if deck2 wins
def recursive_combat(deck1, deck2)
  rounds = Set.new
  while deck1.any? && deck2.any?
    round = deck1.join(",") + ";" + deck2.join(",")
    return true if rounds.include?(round)
    rounds << round
    c1, c2 = deck1.shift, deck2.shift

    if deck1.count >= c1 && deck2.count >= c2
      round_result = recursive_combat(deck1.first(c1), deck2.first(c2))
    else
      round_result = c1 > c2
    end
    if round_result
      deck1.push c1, c2
    else
      deck2.push c2, c1
    end
  end
  deck1.any?
end

deck = recursive_combat(deck1, deck2) ? deck1 : deck2
puts deck.count.downto(1).to_a.zip(deck).map{|i,j| i*j }.inject(:+)

puts deck1.inspect
puts deck2.inspect
