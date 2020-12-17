count = 0
passwords = File.readlines(ARGV[0]).each do |line|
  min, max, letter, _, password = line.split(/[- :]/)
  min = min.to_i
  max = max.to_i
  if password.count(letter).between?(min, max)
    puts line
    count += 1
  end
end
puts count
