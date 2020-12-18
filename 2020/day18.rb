input = File.readlines("input", chomp:true)

total = 0
input.each do |expression|

  stack = []
  output = []

  # Convert to RPN
  expression.each_char do |token|
    next if token == " "
    case token
    when /\d/
      output << token
    when /[+*]/
      # Part 1 just didn't have the precedence condition, i.e., it was just:
      # while stack.any? && stack.last != "("
      while stack.any? && stack.last != "(" && (stack.last == token || (stack.last == "+" && token == "*"))
        output << stack.pop
      end
      stack.push(token)
    when "("
      stack.push(token)
    when ")"
      while stack.last != "(" do
        output << stack.pop
      end
      stack.pop
    else
      raise "boom"
    end
  end
  output << stack.pop while stack.any?

  # Evaluate RPN
  output.each do |token|
    if token.match?(/\d/)
      stack.push(token.to_i)
    else
      n1 = stack.pop
      n2 = stack.pop
      stack.push(token == "+" ? n1 + n2 : n1 * n2)
    end
  end

  puts expression
  puts output.inspect
  result = stack.pop
  total += result
end
puts total
