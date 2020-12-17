input = File.readlines("input", chomp:true)

blank = input.index("")

raw_rules = input[0..blank-1]
mine = input[blank+2]
nearby = input[blank+5..].map { |ticket| ticket.split(",").map(&:to_i) }

rules = raw_rules.map { |rule|
          rule.match(/(?<field>.*): (?<min1>\d*)-(?<max1>\d*) or (?<min2>\d*)-(?<max2>\d*)/)
              .named_captures
              .inject({}) { |h, (k, v)| h[k] = k == "field" ? v : v.to_i ; h }
        }

invalid_values_sum = 0
nearby.each do |ticket|
  ticket.each do |value|
    valid_for_some_rule = false
    rules.each do |rule|
      valid_for_some_rule = value.between?(rule["min1"], rule["max1"]) ||
                            value.between?(rule["min2"], rule["max2"])
      break if valid_for_some_rule
    end
    if not valid_for_some_rule
      invalid_values_sum += value
    end
  end
end
puts invalid_values_sum



