input = File.readlines("input", chomp:true)

connections = input.map { |line| line.split("-") }
$map = Hash.new { |hash, key| hash[key] = [] }
connections.each do |cave1, cave2|
  $map[cave1] << cave2 unless cave2 == "start"
  $map[cave2] << cave1 unless cave1 == "start"
end

$path_count = 0
def traverse(path)
  if path.last == "end"
    # puts path.join(",")
    $path_count += 1
    return
  end
  $map[path.last].each do |candidate|
    candidate_path = path + [candidate]
    small_counts_in_candidate = candidate_path.filter { |cave| cave == cave.downcase } \
                                              .group_by { |cave| cave }
                                              .values
                                              .map(&:count)
    next if small_counts_in_candidate.any? { |c| c > 2 }    # At most two visits per small cave
    next if small_counts_in_candidate.count { |c| c > 1 } > 1 # At most one small cave with two visits
    traverse(candidate_path)
  end
end

traverse(["start"])
puts $path_count
