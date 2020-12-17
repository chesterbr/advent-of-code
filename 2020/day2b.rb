count = 0
passwords = File.readlines(ARGV[0]).each do |line|
  p1, p2, letter, _, password = line.split(/[- :]/)
  p1 = p1.to_i - 1
  p2 = p2.to_i - 1
  cond1 = password[p1] == letter
  cond2 = password[p2] == letter
  if cond1 ^ cond2
    puts line
    count += 1
  end
end
puts count
