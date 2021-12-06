input = File.readlines("input", chomp:true)

timers = input.first.split(",").map(&:to_i)
fish_counts_by_timer = [0] * 10

timers.each do |timer|
  fish_counts_by_timer[timer] += 1
end

1.upto(256) do
  puts fish_counts_by_timer.inspect
  fishes_that_will_pass_zero = fish_counts_by_timer[0]
  0.upto(8) do |timer|
    fish_counts_by_timer[timer] = fish_counts_by_timer[timer + 1]
  end
  fish_counts_by_timer[6] += fishes_that_will_pass_zero
  fish_counts_by_timer[8] += fishes_that_will_pass_zero
end

puts fish_counts_by_timer.sum
