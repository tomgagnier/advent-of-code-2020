#!/usr/bin/env ruby
# frozen_string_literal: true

# An integral two dimensional point
Point = Struct.new(:x, :y) do
  def +(other)
    Point.new(x + other.x, y + other.y)
  end
end

# A path based on an origin and slope
class Path
  include Enumerable

  def initialize(slope:, origin: Point.new(0, 0))
    @slope = slope
    @origin = origin
  end

  # An infinite sequence - it must be evaluated with limits or lazily
  def each(&block)
    position = @origin.clone
    loop do
      block.call(position)
      position += @slope
    end
  end
end

# The Toboggan terrain map
class Terrain
  def initialize(filename:)
    @rows = File.readlines(filename).map { |l| l.chomp.each_char.map { |c| c == '.' ? :open : :tree } }
  end

  def type_of(point)
    point.y < @rows.length ? @rows[point.y][point.x % @rows[point.y].length] : :out_of_bounds
  end

  def count_trees_on(path)
    path.lazy
        .map { |position| type_of(position) }
        .take_while { |type| type != :out_of_bounds }
        .count { |type| type == :tree }
  end
end

terrain = Terrain.new(filename: 'problem-input.txt')

# Part 1
puts terrain.count_trees_on(Path.new(slope: Point.new(3, 1)))

# Part 2
slopes = [Point.new(1, 1), Point.new(3, 1), Point.new(5, 1), Point.new(7, 1), Point.new(1, 2)]
puts slopes.map { |slope| terrain.count_trees_on(Path.new(slope: slope)) }
           .reduce(:*)
