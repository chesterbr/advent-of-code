input = File.readlines("input", chomp:true)

connections = input.map { |line| line.split("-") }
$map = Hash.new { |hash, key| hash[key] = [] }
connections.each do |cave1, cave2|
  $map[cave1] << cave2
  $map[cave2] << cave1
end

$path_count = 0
def traverse(path)
  if path.last == "end"
    # puts path.join(",")
    $path_count += 1
    return
  end
  $map[path.last].each do |candidate|
    next if path.map(&:downcase).include? candidate
    traverse(path + [candidate])
  end
end

traverse(["start"])
puts $path_count
