require "set"
input = File.readlines("input", chomp:true)

input.map! do |line|
  ingredients, allergens = line.chomp(")").split(" (contains ")
  {
    ingredients: ingredients&.split(" "),
    allergens: allergens&.split(", ") || []
  }
end

pairs_in_lines = input.map do |line|
  line[:ingredients].product(line[:allergens])
end
known_ingredients = pairs_in_lines.reduce(&:+).map(&:first).uniq

pairs_in_lines.each do |pairs|
  pairs.reject! do |ingredient, allergen|
    result = input.any? { |line| line[:allergens].include?(allergen) &&
                                 !line[:ingredients].include?(ingredient)  }
    result
  end
end

ingredients_that_can_have_allergens = pairs_in_lines.reduce(&:+).map(&:first).uniq
ingredients_with_no_allergens = known_ingredients - ingredients_that_can_have_allergens

# Part 1

count = 0
ingredients_with_no_allergens.each do |ingredient|
  count += input.count { |line| line[:ingredients].include? ingredient }
end
puts count

# Part 2
allergen_to_ingredient = {}
while single_pair_line = pairs_in_lines.find { |pairs| pairs.count == 1 }
  ingredient, allergen = single_pair_line.first
  allergen_to_ingredient[allergen] = ingredient
  pairs_in_lines.each do |pairs|
    pairs.reject! { |i, _| i == ingredient }
  end
end
puts allergen_to_ingredient.sort.map(&:last).join(",")
