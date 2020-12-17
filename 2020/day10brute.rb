adaptors = File.readlines("input.txt", chomp:true).map(&:to_i)

adaptors.sort!
adaptors.unshift(0)
adaptors.push(adaptors.last + 3)

def valid?(adaptors)
  0.upto(adaptors.count - 2) do |i|
    if adaptors[i+1] - adaptors[i] > 3
      return false
    end
  end
  return true
end

require "set"

def valid_combinations(adaptors)
  combinations = Set.new
  combinations << adaptors
  1.upto(adaptors.count - 2) do |i|
    adaptor = adaptors[i]
    smaller = adaptors-[adaptor]
    if valid?(smaller)
      combinations << smaller
      combinations.merge(valid_combinations(smaller))
    end
  end
  combinations
end

puts valid_combinations(adaptors).count
# puts (adaptors-[7]).inspect
# puts "foo"
# puts valid?(adaptors-[1])
