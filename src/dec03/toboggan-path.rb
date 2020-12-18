require_relative '../aoc'

# The Toboggan terrain map
class Terrain
  def initialize(filename:)
    @rows = File.readlines(filename).map { |l| l.chomp.each_char.map { |c| c == '.' ? :open : :tree } }
  end

  def type_of(point)
    point.y < @rows.length ? @rows[point.y][point.x % @rows[point.y].length] : :out_of_bounds
  end

  def count_trees_on(ray)
    ray.lazy
        .map { |position| type_of(position) }
        .take_while { |type| type != :out_of_bounds }
        .count { |type| type == :tree }
  end
end

terrain = Terrain.new(filename: 'problem-input.txt')

# Part 1
puts terrain.count_trees_on(ray(slope: xy(3, 1), origin: xy(0, 0)))

# Part 2
slopes = [xy(1, 1), xy(3, 1), xy(5, 1), xy(7, 1), xy(1, 2)]
puts slopes.map { |slope| terrain.count_trees_on(ray(slope: slope, origin: xy(0, 0))) }
           .reduce(:*)
