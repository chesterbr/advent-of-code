input = File.readlines("input", chomp:true)

@target_x1, @target_x2, @target_y1, @target_y2 = /x=(-?\d+)..(-?\d+), y=(-?\d+)..(-?\d+)/.match(input.first).captures.map(&:to_i)

def target_hit?(x_velocity, y_velocity)
  x, y = 0, 0
  loop do
    return false if x > @target_x2
    return true if x >= @target_x1 && y >= @target_y1 && y <= @target_y2
    return false if x_velocity == 0 && y < @target_y1

    x += x_velocity
    y += y_velocity
    x_velocity -= (x_velocity.abs / x_velocity) if x_velocity > 0
    y_velocity -= 1
  end
end

def max_y(y_velocity)
  return 0 if y_velocity < 0
  (y_velocity * (y_velocity + 1)) / 2
end

min_x_velocity = 1
max_x_velocity = 500
min_y_velocity = -500
max_y_velocity = 500

global_max_y = 0
min_x_velocity.upto(max_x_velocity) do |x_velocity|
  min_y_velocity.upto(max_y_velocity) do |y_velocity|
    if target_hit?(x_velocity, y_velocity)
      global_max_y = [max_y(y_velocity), global_max_y].compact.max
    end
  end
end

puts global_max_y
