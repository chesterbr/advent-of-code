input = File.readlines("input", chomp:true)
original_cups = input.first.split("").map(&:to_i)
MAX_CUP = 1_000_000
moves = 10_000_000

# Cup is a node of circular linked list, for which
# cup_for_label provides constant time lookup (and will
# never change once initialized)
class Cup
  attr_accessor :label, :next
end

# Initialize the list and array
cup_for_label = Array.new(MAX_CUP)
last_cup = nil
1.upto(MAX_CUP) do |i|
  cup = Cup.new
  if last_cup
    first_cup = last_cup.next
    last_cup.next = cup
    cup.next = first_cup
  else
    cup.next = cup
  end
  cup.label = (i <= original_cups.count ? original_cups[i - 1] : i)
  cup_for_label[cup.label] = cup
  last_cup = cup
end

# For debugging
def print_cups(first, current = nil)
  current = current || first
  output = "cups: "
  cup = first
  MAX_CUP.times do
    output << (cup == current ? "(#{cup.label})" : " #{cup.label} ")
    cup = cup.next
  end
end

current_cup = last_cup.next
first_cup = current_cup # just for printing

1.upto(moves) do |move|
  # print_cups(first_cup, current_cup)

  pick_up = [current_cup.next, current_cup.next.next, current_cup.next.next.next]
  pick_up_values =

  destination_label = current_cup.label - 1
  destination_label = MAX_CUP if destination_label == 0
  while pick_up.map(&:label).any?(destination_label) do
    destination_label -= 1
    destination_label = MAX_CUP if destination_label == 0
  end
  destination_cup = cup_for_label[destination_label]

  next_for_destination_cup = pick_up.first
  next_for_pick_up         = destination_cup.next
  next_for_current_cup     = pick_up.last.next
  current_cup.next = next_for_current_cup
  destination_cup.next = next_for_destination_cup
  pick_up.last.next = next_for_pick_up

  current_cup = current_cup.next
end

# print_cups(first_cup, current_cup)

l1, l2 = cup_for_label[1].next.label, cup_for_label[1].next.next.label
