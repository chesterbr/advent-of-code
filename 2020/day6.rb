require "set"

lines = File.readlines(ARGV[0], chomp:true)
lines << ""
questions_everyone_answered = nil
count = 0
lines.each do |line|
  questions_this_person_answered = line.split("")
  if questions_everyone_answered.nil?
    questions_everyone_answered = questions_this_person_answered
  elsif line.strip != ""
    questions_everyone_answered = questions_this_person_answered & questions_everyone_answered
  end
  next unless line.strip == ""
  puts questions_everyone_answered.inspect
  count += questions_everyone_answered.count

  questions_everyone_answered = nil
end
puts count
