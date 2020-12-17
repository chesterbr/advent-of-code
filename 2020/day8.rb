require "set"

def acc_when_terminates(lines)
  pc = 0
  acc = 0
  visited_pc = []
  while true
    if pc == lines.count
      return acc
    end
    if visited_pc.include? pc
      return false
    end
    opcode, argument = lines[pc].split(" ")
    argument = argument.to_i
    visited_pc << pc
    case opcode
    when "acc"
      acc += argument
      pc += 1
    when "jmp"
      pc += argument
    when "nop"
      pc += 1
    end
  end
end

original = File.readlines("input.txt", chomp:true)

puts original.inspect
0.upto(original.count-1) do |i|
  next if original[i].start_with? "acc"
  patched = original.clone.map(&:clone)
  patched[i][0..2] = original[i].start_with?("nop") ? "jmp" : "nop"
  acc = acc_when_terminates(patched)
  next unless acc
  puts acc
  return
end


