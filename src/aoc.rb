# Shared Advent of Code Utilities

require 'set'

# IO ##################################################################

def read_lines(file_path)
  File.readlines(file_path).map(&:strip).reject(&:empty?)
end

def read_integers(file_path)
  File.readlines(file_path).map(&:strip).reject(&:empty?).map(&:to_i)
end

def group_lines_by_paragraphs(file_path)
  paragraphs = File.readlines(file_path).map(&:strip).reduce([[]]) do |paragraphs, line|
    line.empty? ? paragraphs << [] : paragraphs[-1] << line
    paragraphs
  end
  paragraphs.pop if paragraphs[-1].empty?
  paragraphs
end

# Strings ##############################################################

def to_symbol(s)
  s.strip.gsub(' ', '_').to_sym
end

# Binary ###############################################################

# Translate a string representation of a bitfield to an integer
def binary_code_to_i(code:, zero_char: '0')
  code.each_char.map { |c| c == zero_char ? 0 : 1 }.join.to_i(2)
end

# Utility #############################################################

def assert(&assertion)
  raise 'assertion failed' unless assertion.call
end

def assert_equal(a, b)
  raise "#{a} != #{b}" unless a == b
end

# Geometry #############################################################

# An integral two dimensional vector
Point = Struct.new(:x, :y) do
  def +(other)
    xy(x + other.x, y + other.y)
  end

  def -(other)
    xy(x - other, y - other.y)
  end

  def rotate(radians:, origin: xy(0, 0))
    c = Math.cos(radians)
    s = Math.sin(radians)

    translated = itself - origin

    xy(translated.x * c - translated.y * s,
       translated.x * s + translated.y * c) + origin
  end
end

def xy(x, y)
  Point.new(x, y)
end

# A  in space with a directed magnitude
class Ray
  include Enumerable

  def initialize(slope:, origin: xy(0, 0))
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

def ray(slope:, origin: xy(0, 0))
  Ray.new(slope: slope, origin: origin)
end

class Grid
  def initialize(rows)
    @grid = rows
  end

  def self.from_string(string)
    chars = string.split(/\n/).reverse.map { |row| row.chars }
    Grid.new(Array.new(chars[0].size).each_with_index.map { |col, i|
      Array.new(chars.size).each_with_index.map { |char, j| char = chars[j][i] } })
  end

  def self.read(file_path)
    from_string(read(file_path))
  end

  def ==(o)
    to_s == o.to_s
  end

  def to_s
    max_j.downto(0).map do |j|
      (0..max_i).reduce('') { |s, i| s += @grid[i][j] }
    end.join("\n")
  end

  def max_i
    @grid.size - 1
  end

  def max_j
    @grid[0].size - 1
  end

  def [](i)
    @grid[i]
  end

  def adjacent_to(i, j)
    [[i - 1, j - 1], [i - 1, j], [i - 1, j + 1],
     [i, j - 1], [i, j + 1],
     [i + 1, j - 1], [i + 1, j], [i + 1, j + 1]]
      .filter { |x, y| x.between?(0, max_i) && y.between?(0, max_j) }
  end
end

