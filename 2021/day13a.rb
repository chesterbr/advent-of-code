input = File.readlines("input", chomp:true)

folds, coords = input.compact.partition { |line| line.start_with? "fold" }

x_max = y_max = 0
paper = Hash.new(".")
coords.each do |coord|
  next if coord.empty?
  x, y = coord.split(",").map(&:to_i)
  paper[[y, x]] = "#"
  x_max = [x, x_max].max
  y_max = [y, y_max].max
end

def print_visible_dots(paper, y_max, x_max)
  visible_dots = 0
  (0..y_max).each do |y|
    (0..x_max).each do |x|
      visible_dots += 1 if paper[[y, x]] == "#"
    end
  end
  puts "Visible dots: #{visible_dots}"
  puts
end

print_visible_dots paper, y_max, x_max

folds.each_with_index do |fold, index|
  fold_along_y = fold.start_with?("fold along y")

  0.upto(y_max / (fold_along_y ? 2 : 1)) do |y|
    0.upto(x_max / (fold_along_y ? 1 : 2)) do |x|
      folding_coords = fold_along_y ? [y_max - y, x] : [y, x_max - x]
      paper[[y, x]] = paper[folding_coords] if paper[[y, x]] == "."
    end
  end

  if fold_along_y
    y_max = y_max / 2 - 1
  else
    x_max = x_max / 2 - 1
  end
  puts "After fold #{index + 1}"
  print_visible_dots paper, y_max, x_max
  break # part 1 only requires the first fold
end

