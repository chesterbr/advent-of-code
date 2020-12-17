input = File.readlines("input", chomp:true)

ACTIVE = "#"
INACTIVE = "."

# cubes are [x,y,z] arrays. We only store the active ones
cubes = []
input.each_with_index do |line, y|
  line.split("").each_with_index do |cube, x|
    next if cube != ACTIVE
    cubes << [x, y, 0]
  end
end

def print(cubes)
  xs, ys, zs = cubes.transpose
  zs.uniq.sort.each do |z|
    puts "z=#{z}"
    ys.min.upto(ys.max) do |y|
      line = ""
      xs.min.upto(xs.max) do |x|
        line << (cubes.any?([x,y,z]) ? ACTIVE : INACTIVE)
      end
      puts line
    end
  puts
  end
end

def active_count_in_neighbours(cubes, xx, yy, zz)
  count = 0
  (zz-1).upto(zz+1) do |z|
    (yy-1).upto(yy+1) do |y|
      (xx-1).upto(xx+1) do |x|
        next if [z, y, x] == [zz, yy, xx]
        count += 1 if cubes.any?([x, y, z])
      end
    end
  end
  count
end

def cycle(cubes)
  new_cubes = []
  xs, ys, zs = cubes.transpose
  (zs.min - 1).upto(zs.max + 1) do |z|
    (ys.min - 1).upto(ys.max + 1) do |y|
      (xs.min - 1).upto(xs.max + 1) do |x|
        active = cubes.any?([x, y, z])
        if (active && active_count_in_neighbours(cubes, x, y, z).between?(2, 3)) ||
           (!active && active_count_in_neighbours(cubes, x, y, z) == 3)
          new_cubes << [x, y, z]
        end
      end
    end
  end
  new_cubes
end

print cubes
1.upto(6) do |n|
  puts
  puts "After #{n} cycles:"
  cubes = cycle(cubes)
  print cubes
end

puts cubes.count
