program = File.readlines("input", chomp:true)

mem = {}
or_mask = and_mask = 0
program.each do |statement|
  puts
  puts statement
  command, argument = statement.split(" = ")
  if command == "mask"
    or_mask = argument.gsub(/[X]/,"0").to_i(2) # sets "1" bits
    and_mask = argument.gsub(/[X]/,"1").to_i(2) # resets "0" bits
    puts argument, argument.gsub(/[X]/,"0"), argument.gsub(/[X]/,"1"), or_mask, and_mask
  elsif captures = /mem\[(\d+)\]/.match(command)
     puts "REPLACING!!! value: #{mem[captures[1].to_i]}" if mem[captures[1].to_i]
    mem[captures[1].to_i] = ((argument.to_i | or_mask) & and_mask)
    puts captures[1], argument.to_i, mem[captures[1].to_i]
  else
    raise "boom"
  end
end

puts mem.inspect
puts mem.values.inspect
puts mem.values.sum
