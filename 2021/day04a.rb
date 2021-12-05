class Board
  def initialize(input_lines)
    @lines = input_lines.map { |line| line.split(" ") }
    @transposed_lines = @lines.transpose
    @unmarked_numbers = @lines.flatten
  end

  def mark_drawn(number)
    @unmarked_numbers.delete(number)
  end

  def winning?
    has_winning_row?(@lines) ||  has_winning_row?(@transposed_lines)
  end

  def final_score(called_number)
    @unmarked_numbers.map(&:to_i).sum * called_number.to_i
  end

  private

  def has_winning_row?(lines)
    lines.any? do |line|
      line - @unmarked_numbers == line
    end
  end
end

lines = File.readlines("input", chomp:true)
drawn_numbers = lines[0].split(",")
boards = []

pos = 2
while pos < lines.count
  boards << Board.new(lines[pos..pos+4])
  pos += 6
end

drawn_numbers.each do |drawn_number|
  boards.each do |board|
    board.mark_drawn(drawn_number)
    if board.winning?
      puts board.final_score(drawn_number)
      return
    end
  end
end

