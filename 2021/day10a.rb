input = File.readlines("input", chomp:true)

DELIMITERS = {
  "(" => ")",
  "[" => "]",
  "{" => "}",
  "<" => ">",
}

POINTS_FOR_ILLEGAL_CHAR ={
  ")" => 3,
  "]" => 57,
  "}" => 1197,
  ">" => 25137,
}

score = 0
input.each do |line|
  stack = []
  line.split("").each do |char|
    if DELIMITERS[char]
      stack.push(char)
    else
      expected_char = DELIMITERS[stack.pop]
      if char != expected_char
        puts " - #{line} - Expected #{expected_char}, but found #{char} instead"
        score += POINTS_FOR_ILLEGAL_CHAR[char]
        break
      end
    end
  end
end

puts score
