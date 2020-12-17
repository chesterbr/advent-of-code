
def partition(chars, size, lower_char)
  p1, p2 = 0, size - 1
  chars.each_char do |char|
    middle = (p1 + p2) / 2.0
    if char == lower_char
      p2 = middle.to_i
    else
      p1 = middle.to_i + 1
    end
  end
  raise "whoops" unless p1 == p2
  p1
end

lines = File.readlines(ARGV[0], chomp:true)
seats = []
max = 0
lines.each do |line|
  row_chars, col_chars = line.split(/(?<=^.{7})/)

  row = partition(row_chars, 128, "F")
  col =  partition(col_chars, 8, "L")
  id = row * 8 + col
  puts "#{line}: row #{row}, column #{col}, seat ID #{id}."
  seats[row] ||= []
  seats[row][col] = id
  max = [max, id].max
end
seats.each do |row|
  next unless row
  next unless row.include? nil

  puts "oh "
  puts row.inspect
end
