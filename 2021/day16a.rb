input = File.readlines("input", chomp:true)

# Doing the manual conversion here instead of parametrized to_s/to_i
# just to avoid issues with leading/trailing digits
hex_to_binary  = {
  '0' => [0, 0, 0, 0],
  '1' => [0, 0, 0, 1],
  '2' => [0, 0, 1, 0],
  '3' => [0, 0, 1, 1],
  '4' => [0, 1, 0, 0],
  '5' => [0, 1, 0, 1],
  '6' => [0, 1, 1, 0],
  '7' => [0, 1, 1, 1],
  '8' => [1, 0, 0, 0],
  '9' => [1, 0, 0, 1],
  'A' => [1, 0, 1, 0],
  'B' => [1, 0, 1, 1],
  'C' => [1, 1, 0, 0],
  'D' => [1, 1, 0, 1],
  'E' => [1, 1, 1, 0],
  'F' => [1, 1, 1, 1]
}

bits = input.first.split("").map { |hex_digit| hex_to_binary[hex_digit] }.flatten
@version_sum = 0
LITERAL_VALUE_PACKET_ID = 4

def read_packets(bits, packet_count_to_read: nil, packet_bits_to_read: nil)
  read_packets = 0
  read_bits = 0
  loop do
    version = bits.shift(3).join.to_i(2)
    @version_sum += version
    puts "version: #{version}"
    type_id = bits.shift(3).join.to_i(2)
    read_bits += 6
    if type_id == LITERAL_VALUE_PACKET_ID
      literal_value = 0
      loop do
        last_packet_marker = bits.shift
        packet_value = bits.shift(4).join.to_i(2)
        read_bits += 5
        literal_value <<= 4
        literal_value += packet_value
        break if last_packet_marker == 0
      end
      puts "literal value: #{literal_value}"
    else
      length_type_id = bits.shift
      read_bits += 1
      if length_type_id == 0
        subpackets_length = bits.shift(15).join.to_i(2)
        puts "operator with #{subpackets_length} bits"
        read_bits += 15 + read_packets(bits, packet_bits_to_read: subpackets_length)
      else
        subpacket_count = bits.shift(11).join.to_i(2)
        puts "operator with #{subpacket_count} subpackets"
        read_bits += 11 + read_packets(bits, packet_count_to_read: subpacket_count)
      end
    end
    read_packets += 1
    break if packet_count_to_read && read_packets == packet_count_to_read
    break if packet_bits_to_read && read_bits == packet_bits_to_read
  end

  read_bits
end

read_packets(bits, packet_count_to_read: 1)

puts "version sum: #{@version_sum}"
