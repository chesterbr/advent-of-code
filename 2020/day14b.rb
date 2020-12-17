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

# puts mem.inspect
puts mem.values.sum

# value = 26.to_s(2).rjust(36, "0")
# mask = "00000000000000000000000000000000X0XX"
# values = []
# puts value
# puts mask
# puts
# puts apply_mask(mask, value).map{|x| x.to_i(2)}.inspect




# def apply_mask(mask, value, values)

#   char = mask[0]
#   if char == "0"

# end




# # def apply_mask(mask, value)


# def floating_masks(mask)
#   case mask
#   when "0"
#     return []
#   when "1"
#     return [[:or, "1"]]
#   when "X"
#     return [[:or, "1"], [:and, "0"]]
#   else
#     # floating_masks(mask[0]).each do |left_mask|
#     #   floating_masks(mask[1..]).each do |right_mask|
#   end
# end

# mem = {}
# or_mask = and_mask = 0
# program.each do |statement|
#   puts
#   puts statement
#   command, argument = statement.split(" = ")
#   if command == "mask"
#     or_mask = argument.gsub(/[X]/,"0").to_i(2) # sets "1" bits

#     floating_masks = []


#     and_mask = argument.gsub(/[X]/,"1").to_i(2) # resets "0" bits
#     puts argument, argument.gsub(/[X]/,"0"), argument.gsub(/[X]/,"1"), or_mask, and_mask
#   elsif captures = /mem\[(\d+)\]/.match(command)
#      puts "REPLACING!!! value: #{mem[captures[1].to_i]}" if mem[captures[1].to_i]
#     mem[captures[1].to_i] = ((argument.to_i | or_mask) & and_mask)
#     puts captures[1], argument.to_i, mem[captures[1].to_i]
#   else
#     raise "boom"
#   end
# end

# puts mem.inspect
# puts mem.values.inspect
# puts mem.values.sum
