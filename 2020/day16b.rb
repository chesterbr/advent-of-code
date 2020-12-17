input = File.readlines("input", chomp:true)

blank = input.index("")

raw_rules = input[0..blank-1]
my_values = input[blank+2].split(",").map(&:to_i)
nearby = input[blank+5..].map { |ticket| ticket.split(",").map(&:to_i) }

rules = raw_rules.map { |rule|
          rule.match(/(?<field>.*): (?<min1>\d*)-(?<max1>\d*) or (?<min2>\d*)-(?<max2>\d*)/)
              .named_captures
              .inject({}) { |h, (k, v)| h[k] = k == "field" ? v : v.to_i ; h }
        }

invalid_values_sum = 0
valid_tickets = nearby.filter do |ticket|
  valid_ticket = true
  ticket.each do |value|
    valid_for_some_rule = false
    rules.each do |rule|
      valid_for_some_rule = value.between?(rule["min1"], rule["max1"]) ||
                            value.between?(rule["min2"], rule["max2"])
      break if valid_for_some_rule
    end
    valid_ticket = valid_for_some_rule
    break unless valid_ticket
  end
  valid_ticket
end

fields = rules.map { |rule| rule["field"] }
fields_for_position = Array.new(my_values.count) { |_| fields.clone }

valid_tickets.each do |ticket|
  ticket.each_with_index do |value, position|
    rules.each do |rule|
      valid = value.between?(rule["min1"], rule["max1"]) ||
              value.between?(rule["min2"], rule["max2"])
      if not valid
        fields_for_position[position].delete(rule["field"])
      end
    end
  end
end


while index_of_single = fields_for_position.index{|list| list.is_a?(Array) && list.size == 1}
  single = fields_for_position[index_of_single]
  fields_for_position.map! do |fields|
    fields.is_a?(String) || fields == single ? fields : fields - single
  end
  fields_for_position[index_of_single] = single.first
end

m = 1
my_values.each_with_index do |value, i|
  m *= value if fields_for_position[i].start_with?("departure")
end

puts m


