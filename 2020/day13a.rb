notes = File.readlines("input.txt", chomp:true)

arrival_at_bus_stop = notes.first.to_i
active_buses = notes[1].split(",")
                       .reject { |bus| bus == "x" }
                       .map(&:to_i)


def next_bus_and_time(arrival_at_bus_stop, active_buses)
  candidate_time = arrival_at_bus_stop
  while true
    active_buses.each do |bus|
      if candidate_time % bus == 0
        return [bus, candidate_time]
      end
    end
    candidate_time += 1
  end
end

puts arrival_at_bus_stop
puts active_buses.inspect
bus, time = next_bus_and_time(arrival_at_bus_stop, active_buses)
wait = time - arrival_at_bus_stop
puts bus * wait
