# Receives either a known loop size or a known value,
# returns the other
def transform(subject, known_loop_size: nil, known_value: nil)
  value = 1
  1.upto(10000000) do |loop_size|
    value = (value * subject) % 20201227
    return loop_size if value == known_value
    return value if loop_size == known_loop_size
  end
end

# known_card_pk = 5764801
# known_door_pk = 17807724
known_card_pk = 8335663
known_door_pk = 8614349

card_loop_size = transform(7, known_value: known_card_pk)
puts transform(known_door_pk, known_loop_size: card_loop_size)


