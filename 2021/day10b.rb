input = File.readlines("input", chomp:true)

DELIMITERS = {
  "(" => ")",
  "[" => "]",
  "{" => "}",
  "<" => ">",
}

scores = []
input.each do |line|
  stack = []
  corrupted = false
  line.split("").each do |char|
    if DELIMITERS[char]
      stack.push(DELIMITERS[char])
    else
      expected_char = stack.pop
      if char != expected_char
        corrupted = true
        break
      end
    end
  end
  unless corrupted
    completion = stack.reverse
    score = completion.reduce(0) do |sum, char|
      sum * 5 + "_)]}>".index(char)
    end
    puts " - #{line} - Complete by adding #{completion.join} - #{score} total points"
    scores << score
  end
end

puts scores.sort[scores.size / 2]
