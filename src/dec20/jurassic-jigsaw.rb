require_relative '../aoc'

class Tile
  def initialize(id, matrix)
    @id = id
    @matrix = matrix
  end

  def north
    @north |= @matrix[0]
  end

  def south
    @south |= @matrix[-1]
  end

  def east
    @east |= @matrix.map { |row| row[-1] }
  end

  def west
    @west |= @matrix.map { |row| row[0] }
  end

  def flip
    Tile.new(@id, @matrix.map { |row| row.reverse })
  end

  def rotate
    Tile.new(@id, @matrix.transpose.reverse)
  end

  def to_s
    ["Tile: #{@id}", *@matrix.map { |row| row.join }].join("\n")
  end
end

tile = Tile.new(1, [%w[1 2 3], %w[4 5 6], %w[7 8 9]])
assert_equal("Tile: 1\n123\n456\n789", tile.to_s)
assert_equal("Tile: 1\n321\n654\n987", tile.flip.to_s)
assert_equal("Tile: 1\n369\n258\n147", tile.rotate.to_s)
assert_equal(%w[1 2 3], tile[:N])
assert_equal(%w[3 6 9], tile[:E])
assert_equal(%w[7 8 9], tile[:S])
assert_equal(%w[1 4 7], tile[:W])

class Square

  attr :dimension, :tiles

  def initialize(dimension)
    @dimension = dimension
    @tiles = []
  end

  def complete?
    tiles.size == dimension * dimension
  end

  def [](x, y)
    offset = x + dimension * y
    (0...@tiles.size).include?(offset) ? @tiles[offset] : nil
  end

  def add?(tile)
    offset = @tiles.length
    x = offset % @dimension
    y = offset / @dimension
    if offset < @tiles.length &&
      @tiles.none? { |t| t.id == tile.id } &&
      ([x - 1, y].nil? || [x - 1, y].east == tile.west) &&
      ([x, y - 1].nil? || [x, y - 1].south == tile.north)
      @tiles << tile
      true
    else
      false
    end
  end
end

def read_tiles_in(file_path)
  group_lines_by_paragraphs(file_path).map do |lines|
    id = lines[0].split[1].to_i
    tile0 = Tile.new(id, lines[1..-1].map { |line| line.chars })
    tile1 = tile0.rotate
    tile2 = tile1.rotate
    tile3 = tile2.rotate
    [tile0, tile1, tile2, tile3, tile0.flip, tile1.flip, tile2.flip, tile3.flip]
  end.flatten
end

def foo(tiles,
        dimension = Math.sqrt(tiles.size / 8).truncate,
        square = Square.new(dimension),
        index_stack = [])
  unless square.complete?
    size = index_stack.size
    (0...tiles.size).each do |i|
      if square.add(tiles[i])
        index_stack << i
        break
      end
    end
    if size == index_stack.size
      loop do

      end
    end
  end
end

def evaluate(file_path)
  tiles = read_tiles_in(file_path)
  foo(tiles)
end

evaluate('test-input.txt')

