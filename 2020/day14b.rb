program = File.readlines("input", chomp:true)


def apply_mask(mask, value, prefix = "", result = [])
  if mask == ""
    result << prefix
    return
  end
  case mask[0]
  when "0"
    apply_mask(mask[1..], value[1..], prefix + value[0], result)
  when "1"
    apply_mask(mask[1..], value[1..], prefix + "1", result)
  when "X"
    apply_mask(mask[1..], value[1..], prefix + "0", result)
    apply_mask(mask[1..], value[1..], prefix + "1", result)
  end
  result
end

mem = {}
mask = ""
program.each do |statement|
  command, argument = statement.split(" = ")
  if command == "mask"
    mask = argument
  elsif captures = /mem\[(\d+)\]/.match(command)
    original_address = captures[1].to_i.to_s(2).rjust(36, "0")
    addresses = apply_mask(mask, original_address)
    addresses.each do |address|
      mem[address.to_i(2)] = argument.to_i
    end
  else
    raise "boom"
  end
end

puts mem.values.sum
