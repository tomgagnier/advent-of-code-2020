require_relative '../aoc'

def parse_food_labels(file_path)
  read_lines(file_path)
    .map { |line| /(?<ingredients>[^(]+)(\(contains (?<allergens>[^)]*)\))?/.match(line) }
    .reject(&:nil?)
    .map { |match| { ingredients: match[:ingredients].split.map(&:to_sym),
                     allergens: match[:allergens].split(', ').map(&:to_sym) } }
end

def category(food_labels, category)
  food_labels.reduce([]) { |types, label| types | label[category] }.sort.uniq
end

def foo(ingredients, allergens)
  allergens
    .each { |e| p e }
  foo = (0...ingredients.size)
    .to_a
    .permutation(ingredients.size)
    .filter { |indexes|
      indexes.all? { |i|
        ingredient = ingredients[i]
        possible_ingredients = allergens[i][1]
        possible_ingredients.include?(ingredient)
      }
    }
  p foo.size
end

def part1(file_path)
  food_labels = parse_food_labels(file_path)
  ingredients = category(food_labels, :ingredients)
  allergens = category(food_labels, :allergens)
  allergenic_ingredients = allergens.reduce([]) { |allergenic_ingredients, allergen|
    (food_labels
      .filter { |label| label[:allergens].include?(allergen) }
      .reduce(ingredients) { |intersection, label| intersection & label[:ingredients] } +
      allergenic_ingredients).sort.uniq
  }
  non_allergenic_ingredients = ingredients - allergenic_ingredients
  p food_labels.map { |label| (non_allergenic_ingredients & label[:ingredients]).size }.reduce(:+)

  foo(allergenic_ingredients, allergens.map { |allergen|
    [allergen,
     food_labels
       .filter { |label| label[:allergens].include?(allergen) }
       .map { |label| label[:ingredients] }
       .reduce([]) { |possible_ingredients, label_ingredients| (possible_ingredients + label_ingredients - non_allergenic_ingredients).sort.uniq }]
  })

  # p allergenic_ingredients.map { |ingredient|
  #   [ingredient,
  #    food_labels
  #      .filter { |label| label[:ingredients].include?(ingredient) }
  #      .map { |label| label[:allergens] }
  #      .reduce([]) { |possible_allergens, label_allergens| (possible_allergens + label_allergens).sort.uniq }]
  # }.to_h
end

file_paths = %w[test-input.txt].each { |file_path|
  part1(file_path)
}
