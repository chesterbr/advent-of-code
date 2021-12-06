input = File.readlines("input", chomp:true)

timers = input.first.split(",").map(&:to_i)

1.upto(80) do |day|
  last_index = timers.length - 1
  0.upto(last_index) do |index|
    if timers[index] == 0
      timers[index] = 6
      timers << 8
    else
      timers[index] -= 1
    end
  end
  # puts "After #{day} days: #{timers.join(",")}"
end

puts timers.count
