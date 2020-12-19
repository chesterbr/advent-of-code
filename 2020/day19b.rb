input = File.readlines("input", chomp:true)


pos = input.index("")
raw_rules = input[0..pos - 1]
messages = input[pos + 1..]

# "8: 42 | 42 8"
raw_rules << "8: 42+"

# "11: 42 31 | 42 11 31"
rule = "11: "
1.upto(30) do |i|
  rule << "42 " * i
  rule << "31 " * i
  rule << "| "
end
raw_rules << rule.delete_suffix(' | ')

@rule_tokens = {}
raw_rules.each do |rule|
  number, tokens = rule.split(": ")
  @rule_tokens[number.to_i] = tokens.split(" ")
end

puts @rule_tokens.inspect

def convert_rule_to_regexp(i)
  output = "(?:"
  @rule_tokens[i].each do |token|
    case token
    when /"."/
      output << token[1]
    when /\d+/
      output << convert_rule_to_regexp(token.to_i)
      output << "+" if token.end_with?("+")
    when "|"
      output << "|"
    else
      raise "boom"
    end
  end
  output << ")"
  output
end

re = Regexp.new("^#{convert_rule_to_regexp(0)}$")
puts messages.count { |message| message.match(re) }
