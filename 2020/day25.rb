#  input = File.readlines("input", chomp:true)

def transform(subject, loop_size)
  value = 1
  loop_size.times do
    value = (value * subject) % 20201227
  end
  value
end


@memo = []
def transform_recursive(subject, loop_size)
  return 1 if loop_size == 0
  @memo[subject] ||= []
  @memo[subject][loop_size] ||= (transform_recursive(subject, loop_size - 1) * subject) % 20201227
end

def loop_size_from_pk(pk)
  1.upto(10000000) do |loop_size|
    return loop_size if pk == transform_recursive(7, loop_size)
  end
  raise "loop size not found for #{pk}"
end

# card_pk = transform(7, card_loop_size)
# door_pk = transform(7, card_loop_size)

# known_card_pk = 5764801
# known_door_pk = 17807724
known_card_pk = 8335663   # 5764801
known_door_pk = 8614349   # 17807724

card_loop_size = loop_size_from_pk(known_card_pk)
puts card_loop_size
puts transform(7, card_loop_size)
# door_loop_size = loop_size_from_pk(known_door_pk)

puts transform(known_door_pk, card_loop_size)


