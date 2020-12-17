input = File.readlines("input", chomp:true)

ACTIVE = "#"
INACTIVE = "."

def key(x, y, z, w)
  x + y * 100 + z * 10_000 + w * 1_000_000
end

# cubes were [x,y,z,w] arrays. We only store the active ones
# then we switched to hashes for quicker lookup
cubes = {}
input.each_with_index do |line, y|
  line.split("").each_with_index do |cube, x|
    next if cube != ACTIVE
    cubes[key(x, y, 0, 0)] = [x, y, 0, 0]
  end
end

def unkey(h)
  h.split(",").map(&:to_i)
end

def print(cubes)
  xs, ys, zs, ws = cubes.values.transpose
  ws.uniq.sort.each do |w|
    zs.uniq.sort.each do |z|
      puts "z=#{z}, w=#{w}"
      ys.min.upto(ys.max) do |y|
        line = ""
        xs.min.upto(xs.max) do |x|
          line << (cubes.keys.any?(key(x, y, z, w)) ? ACTIVE : INACTIVE)
        end
        puts line
      end
      puts
    end
  end
end

def active_count_in_neighbours(cubes, xx, yy, zz, ww)
  count = 0
  (ww-1).upto(ww+1) do |w|
    (zz-1).upto(zz+1) do |z|
      (yy-1).upto(yy+1) do |y|
        (xx-1).upto(xx+1) do |x|
          next if [z, y, x, w] == [zz, yy, xx, ww]
          count += 1 if cubes.keys.any?(key(x, y, z, w))
        end
      end
    end
  end
  count
end

def cycle(cubes)
  new_cubes = {}
  xs, ys, zs, ws = cubes.values.transpose
  (ws.min - 1).upto(ws.max + 1) do |w|
    (zs.min - 1).upto(zs.max + 1) do |z|
      (ys.min - 1).upto(ys.max + 1) do |y|
        (xs.min - 1).upto(xs.max + 1) do |x|
          active = cubes.keys.any?(key(x, y, z, w))
          if (active && active_count_in_neighbours(cubes, x, y, z, w).between?(2, 3)) ||
            (!active && active_count_in_neighbours(cubes, x, y, z, w) == 3)
            new_cubes[key(x, y, z, w)] = [x, y, z, w]
          end
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
