require '../aoc'

def read_bags(file)

  def to_array_of_symbols(nested_bags)
    return [] if nested_bags == 'no other bags.'
    nested_bags.split(', ')
               .map { |s| /(?<count>\d+)\s+(?<bag_type>.*) bag/.match(s) }
               .map { |m| Array.new(m[:count].to_i, to_symbol(m[:bag_type])) }
               .flatten
  end

  def walk(bag)
    Enumerator.new do |enum|
      unvisited = itself[bag].clone
      until unvisited.empty?
        visited = unvisited.shift
        enum.yield visited
        unvisited += itself[visited]
      end
    end
  end

  def ancestors_of(bag, ancestors = [bag], candidates = itself)
    return ancestors - [bag] if candidates.empty?
    parents = candidates.reject { |k, bags| ancestors.include?(k) || (bags & ancestors).empty? }
    ancestors_of(bag, ancestors + parents.keys, parents)
  end

  read_lines(file)
    .map { |l| l.split(" bags contain ") }
    .map { |m| [to_symbol(m[0]), to_array_of_symbols(m[1])] }
    .to_h
end

for file_path in %w(test-input.txt input.txt)
  bags = read_bags(file_path)

  p bags.ancestors_of(:shiny_gold)
end

