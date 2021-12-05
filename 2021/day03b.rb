def filter_by_criteria(input, index, type)
  frequency_ones = frequency_zeroes = 0
  input.each do |bits|
    if bits[index] == "1"
      frequency_ones += 1
    else
      frequency_zeroes += 1
    end
  end
  if type == "oxygen"
    if frequency_ones >= frequency_zeroes
      bit_to_filter = 1
    else
      bit_to_filter = 0
    end
  else # type == "co2"
    if frequency_ones >= frequency_zeroes
      bit_to_filter = 0
    else
      bit_to_filter = 1
    end
  end
  input.select { |bits| bits[index] == bit_to_filter.to_s }
end

lines = File.readlines("input", chomp:true)
original_input = lines.map { |line| line.split("") }
ratings = {}

%w(oxygen co2).each do |type|
  input = original_input.dup
  0.upto(input[0].length - 1) do |index|
    input = filter_by_criteria(input, index, type)
    break if input.length == 1
  end
  ratings[type] = input[0].join.to_i(2)
end
puts ratings
puts ratings.values.inject(:*)
