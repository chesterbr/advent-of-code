lines = File.readlines(ARGV[0], chomp:true)
lines << ""
required_keys = %w(byr iyr eyr hgt hcl ecl pid).sort
partial_data = {}
count = 0
lines.each do |line|
  line.split(" ").each do |field|
    key, value, extra = field.split(":")
    raise "ouch" if extra
    partial_data[key] = value
  end
  next unless line.strip == ""
  data = partial_data.clone
  partial_data = {}
  if data.keys.sort - ["cid"] == required_keys
    next unless data["byr"].match?(/^\d{4}$/) && data["byr"].to_i.between?(1920, 2002)
    next unless data["iyr"].match?(/^\d{4}$/) && data["iyr"].to_i.between?(2010, 2020)
    next unless data["eyr"].match?(/^\d{4}$/) && data["eyr"].to_i.between?(2020, 2030)
    next unless data["hgt"].match?(/^\d+(in|cm)$/)
    if data["hgt"].end_with?("cm")
      next unless data["hgt"].to_i.between?(150, 193)
    else
      next unless data["hgt"].to_i.between?(59, 76)
    end
    next unless data["hcl"].match?(/^#[0-9a-f]{6}$/)
    next unless %w(amb blu brn gry grn hzl oth).include? data["ecl"]
    next unless data["pid"].match?(/^\d{9}$/)
    count += 1
  end
end
puts count
