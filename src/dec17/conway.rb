require_relative '../aoc'

# @param active - a Set of active points in a Conway game
# @param rule - activate the point given the active status and number of active neighbors
# @return the set of next Conway generation of active points
def conway(active:, rule:)
  active
    .reduce(Set[]) { |candidates, p| candidates + neighborhood_of(p) }
    .reduce(Set[]) { |next_generation, candidate|
      active_neighbors = neighborhood_of(candidate)
        .filter { |neighbor| active.include?(neighbor) } - [candidate]
      next_generation << candidate if rule.call(active.include?(candidate), active_neighbors.size)
      next_generation }
end

# @return a set of active Conway cells read from the file_path
def read_active(file_path:, dimensions: 0)
  read_lines(file_path)
    .each_with_index
    .flat_map { |line, y|
      line.each_char.each_with_index
          .filter { |c, _| c == '#' }
          .map { |_, x| [x, y] + Array.new(dimensions - 2, 0) } }
    .to_set
end

rule = lambda { |is_active, count| is_active && count.between?(2, 3) || !is_active && count == 3 }

%w(test-input.txt input.txt).each do |file_path|
  puts file_path
  (3..4).each do |dimension|
    active = read_active(file_path: file_path, dimensions: dimension)
    6.times { active = conway(rule: rule, active: active) }
    puts "  dimensions: #{dimension}, active count: #{active.count}"
  end
end

