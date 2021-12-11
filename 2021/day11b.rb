input = File.readlines("input", chomp:true)

width = input[0].length
height = input.length
octopuses = input.map { |line| line.split("").map(&:to_i) }
puts "Before any steps:\n#{octopuses.map { |line| line.join("") }.join("\n")}\n\n"

flashes = 0
1.upto(999999) do |step|
  octopuses.map! { |row| row.map! { |n| n + 1  } }
  loop do
    # puts octopuses.inspect
    flashing = 0
    0.upto(width - 1) do |y|
      0.upto(width - 1) do |x|
        if octopuses[y][x] == 10 # will flash
          flashing += 1
          octopuses[y][x] = 11   # flashing (so we don't count again)
          (y - 1).upto(y + 1) do |y_neighbour|
            (x - 1).upto(x + 1) do |x_neighbour|
              next if x_neighbour == x && y_neighbour == y
              next if x_neighbour < 0 || x_neighbour >= width || y_neighbour < 0 || y_neighbour >= width
              next if octopuses[y_neighbour][x_neighbour] > 9
              octopuses[y_neighbour][x_neighbour] += 1
            end
          end
        end
      end
    end
    flashes += flashing
    break if flashing == 0
  end
  octopuses.map! { |row| row.map! { |n| n > 9 ? 0 : n } }

  puts "After step #{step}:\n#{octopuses.map { |line| line.join("") }.join("\n")}\n\n"
  if octopuses.flatten.count(0) == width * height
    puts "They all flash after step #{step}"
    break
  end
end
