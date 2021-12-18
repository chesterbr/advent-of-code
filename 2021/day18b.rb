input = File.readlines("input", chomp:true)

# We'll store numbers as arrays of tokens ("[", ",", "]", or a number)
numbers = input.map { |line| line.split("").map { |c| Integer(c) rescue c } }

def reduce(number)
  loop do
    next if explode_first_explodable(number)
    next if split_first_splitable(number)
    break
  end
end

def explode_first_explodable(number)
  depth = 0
  left_at_depth = []
  number.each_with_index do |token, i|
    if token == ","
      next
    elsif token == "["
      depth += 1
    elsif token == "]" || token == nil
      left_at_depth[depth] = nil
      depth -= 1
    elsif left_at_depth[depth] == nil
      left_at_depth[depth] = token
    elsif depth > 4
      # Found a pair inside 4 other pairs, explode to both sides
      left, right = left_at_depth[depth], token
      (i - 3).downto(0) do |i_left|
        if number[i_left].is_a? Integer
          number[i_left] = number[i_left] + left
          break
        end
      end
      (i + 1).upto(number.length - 1) do |i_right|
        if number[i_right].is_a? Integer
          number[i_right] = number[i_right] + right
          break
        end
      end
      # Replace the pair with zero
      (i - 3).upto(i + 1) { |i_pair| number[i_pair] = nil }
      number[i] = 0
      number.compact!
      return true
    end
  end
  false
end

def split_first_splitable(number)
  number.each_with_index do |token, i|
    if token.is_a?(Integer) && token >= 10
      # Split the number into two digits
      left,right = token / 2, (token / 2.0).ceil
      number[i] = "]"
      number.insert(i, "[", left, ",", right)
      return true
    end
  end
  false
end

def sum(a, b)
  ["[", *a, ",", *b, "]"]
end

def magnitude(number)
  return number if number.is_a? Integer
  number = eval(number) if number.is_a? String

  3 * magnitude(number.first) + 2 * magnitude(number.last)
end

magnitudes = numbers.product(numbers).map do |n1, n2|
  next 0 if n1 == n2
  candidate = sum(n1, n2)
  reduce(candidate)
  magnitude(candidate.join)
end

puts magnitudes.max
