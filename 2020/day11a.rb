layout = File.readlines("input.txt", chomp:true)

EMPTY ="L"
OCCUPIED = "#"

def adjacent_seats(layout, y, x)
  result = []
  [y - 1, 0].max.upto([y + 1, layout.size - 1].min) do |yy|
    [x - 1, 0].max.upto([x + 1, layout[y].size - 1].min) do |xx|
      next if (yy == y && xx == x) # don't count yourself
      result << layout[yy][xx]
    end
  end
  result
end

def apply_rules(layout)
  new_layout = layout.clone.map(&:clone)
  0.upto(layout.size - 1) do |y|
    0.upto(layout[y].size - 1) do |x|
      if layout[y][x] == EMPTY && adjacent_seats(layout, y, x).count(OCCUPIED) == 0
        new_layout[y][x] = OCCUPIED
      elsif layout[y][x] == OCCUPIED && adjacent_seats(layout, y, x).count(OCCUPIED) >= 4
        new_layout[y][x] = EMPTY
      end
    end
  end
  new_layout
end

previous_layout = []
while previous_layout != layout
  previous_layout = layout
  layout = apply_rules(layout)
end

puts layout.join.count(OCCUPIED)
