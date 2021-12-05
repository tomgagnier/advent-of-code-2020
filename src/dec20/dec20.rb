require 'set'
require 'prime'
require 'scanf'

class ZHash < Hash
  def initialize
    super {|h, k| h[k] = 0}
  end
end

# Grid module with following helpers:
#
# G.empty
# G.copy(grid)
# G.in_bounds?(x, y)
# G.points
# G.values(grid)
# G.points_and_values(grid, &block)
# G.puts(grid)
# G.directions
# G.neighbor_points(x, y)
# G.neighbors(grid, x, y)
module G
  # For grid inputs like:
  # .3..###..
  # ...1# ..#
  # ..#  ...#
  # 5...8..#.
  def self.get_grid_input(original_filename)
    strs = get_input_str_arr(original_filename)

    $HEIGHT = strs.length
    $WIDTH = strs[0].length

    grid = self.empty

    strs.each.with_index do |str, y|
      str.chars.each.with_index do |ch, x|
        grid[x][y] = ch
      end
    end

    [grid, strs.length, strs[0].length]
  end

  def self.empty
    Array.new($WIDTH) { Array.new($HEIGHT) }
  end

  def self.copy(grid)
    new_grid = grid.dup
    grid.count.times do |i|
      new_grid[i] = grid[i].dup
    end
  end

  def self.in_bounds?(x, y)
    0 <= x && x < $WIDTH && 0 <= y && y < $HEIGHT
  end

  def self.points
    return @points if @points
    @points = []

    $WIDTH.times do |x|
      $HEIGHT.times do |y|
        @points << [x, y]
      end
    end

    @points
  end

  def self.values(grid)
    self.points.map do |x, y|
      grid[x][y]
    end
  end

  def self.points_and_values(grid, &block)
    self.points.map do |x, y|
      [x, y, grid[x][y]]
    end
  end

  def self.puts(grid)
    $HEIGHT.times do |y|
      $WIDTH.times do |x|
        print grid[x][y]
      end
      print "\n"
    end
  end

  def self.directions
    [
      [-1, -1],
      [-1,  0],
      [-1,  1],
      [ 0, -1],
      [ 0,  1],
      [ 1, -1],
      [ 1,  0],
      [ 1,  1],
    ]
  end

  def self.neighbor_points(x, y)
    neighbor_points = []

    directions.each do |dx, dy|
      next if !in_bounds?(x + dx, x + dy)

      neighbor_points << [x + dx, y + dy]
    end

    neighbor_points
  end

  def self.neighbors(grid, x, y)
    neighbor_points(x, y).map {|nx, ny| grid[nx][ny]}
  end
end
# Has the content "session=<base64>"
COOKIE_FILE = 'cookie'

YEAR=2020

def strip_newlines(strs)
  strs.map {|str| str.delete_suffix("\n")}
end

# Run ./decXX.rb <test_name> to run code on input in file decXX.<test_name>.
#
# For input like:
# a
# b
# c
def get_input_str_arr(original_filename)
  dot_slash_date = original_filename.chomp('.rb')
  date = dot_slash_date.delete_prefix('./')
  day = date.delete_prefix('dec').to_i.to_s

  if ARGV[0]
    strip_newlines(File.readlines("#{dot_slash_date}.#{ARGV[0]}"))
  else
    true_input_filename = "#{date}.input"
    true_input = nil

    if File.exist?(true_input_filename)
      true_input = strip_newlines(File.readlines("#{dot_slash_date}.input"))
    end

    if !true_input
      puts "Fetching input for day #{date}..."

      # Call .to_i.to_s to get rid of leading 0 for Dec. 1-9.
      cookie = File.read(COOKIE_FILE).strip

      curl_command =
        "curl https://adventofcode.com/#{YEAR}/day/#{day}/input "\
          "-H 'cache-control: max-age=0' "\
          "-H 'cookie: #{cookie}' "\
          "--output #{true_input_filename} "

      system(curl_command)

      true_input = strip_newlines(File.readlines("#{dot_slash_date}.input"))
    end

    if true_input.empty? ||
      true_input[0].start_with?("Please don't repeatedly request") ||
      true_input[0] == "404 Not Found"
      puts "Input for day #{dot_slash_date} was fetched prematurely..."
      exit(1)
    end

    true_input
  end
end

# For input like:
# a
# b
#
# abc
#
# a
# b
# c
def str_groups_separated_by_blank_lines(original_filename)
  groups = []
  curr_group = []

  get_input_str_arr(original_filename).each do |str|
    if str == ''
      groups << curr_group
      curr_group = []
      next
    end

    curr_group << str
  end

  groups << curr_group
  groups
end

# For input like:
# here-is-some-text
def get_input_str(original_filename)
  get_input_str_arr(original_filename)[0]
end

# For input like:
# 1,2,3
def get_single_line_input_int_arr(original_filename, separator: ',')
  get_input_str(original_filename).split(separator).map(&:to_i)
end

# For input like:
# 1
# 2
# 3
def get_multi_line_input_int_arr(original_filename)
  get_input_str_arr(original_filename).map(&:to_i)
end

require '../aoc'
grouped_strs = group_lines_by_paragraphs('input.txt')

$edge_counts = ZHash.new

$tiles_to_edges = {}

$edge_vals_to_tiles = Hash.new {|h, k| h[k] = []}

def edge_to_i(edge)
  n = 0

  edge.chars.each_with_index do |ch, i|
    n += 2 ** i if ch == '#'
  end

  n
end

$tile_nums_to_outer_tile = {}
$tile_nums_to_inner_tile = {}

grouped_strs.each do |tile|
  tile_num = tile[0].split(" ")[1].to_i

  tile.shift

  # This made my input easier to work with lol
  tile.each {|row| row.reverse!}

  edge0 = tile[0]
  edge1 = tile.last
  edge2 = tile.map(&:chars).map(&:first).join("")
  edge3 = tile.map(&:chars).map(&:last).join("")

  all = []
  [edge0, edge1, edge2, edge3].each do |edge|
    all << edge_to_i(edge)
    all << edge_to_i(edge.reverse)
  end

  all = all.uniq

  all.each do |val|
    $edge_counts[val] += 1
    $edge_vals_to_tiles[val] << tile_num
  end

  inner_tile = tile[1..-2]
  inner_tile.map! {|str| str[1..-2]}

  $tile_nums_to_inner_tile[tile_num] = inner_tile
  $tile_nums_to_outer_tile[tile_num] = tile

  $tiles_to_edges[tile_num] = all
end

corner_tile = nil

prod = 1
$tiles_to_edges.each do |tile_num, edge_vals|
  # puts "Tile #{tile_num} has #{num_matching} matching edges"
  if edge_vals.count {|edge| $edge_counts[edge] == 2} == 4
    corner_tile = tile_num
    prod *= tile_num
  end
end

puts "Part 1: #{prod}"

# Reassemble image


def get_neighbors_of_tile(tile_num)
  s = Set.new

  $tiles_to_edges[tile_num].each do |edge|
    $edge_vals_to_tiles[edge].each do |neighbor_tile|
      s << neighbor_tile if neighbor_tile != tile_num
    end
  end

  s
end

NUM_TILES = $tiles_to_edges.count # 144
SIZE = Math.sqrt(NUM_TILES).to_i
image = []
SIZE.times {image << Array.new(SIZE)}

image[0][0] = corner_tile
# corner_neighbors = get_neighbors_of_tile(corner_tile).to_a
# image[0][1] = corner_neighbors[0]
# image[1][0] = corner_neighbors[1]

# puts corner_tile
# puts get_neighbors_of_tile(corner_tile).inspect
# puts image.inspect

used_tiles = Set.new
used_tiles << corner_tile

def get_remaining_neighbor_tile(tile1, tile2, used_tiles)
  tile1_possibilities = get_neighbors_of_tile(tile1)
  # puts "Around tile1: #{tile1_possibilities.to_a}"
  tile1_possibilities.to_a.each {|t| tile1_possibilities.delete(t) if used_tiles.include?(t)}
  # puts "Around tile1 (and unused): #{tile1_possibilities.to_a}"

  if tile2
    tile2_possibilities = get_neighbors_of_tile(tile2)
    # puts "Around tile2: #{tile2_possibilities.to_a}"
    tile2_possibilities.to_a.each {|t| tile2_possibilities.delete(t) if used_tiles.include?(t)}
    # puts "Around tile2 (and unused): #{tile2_possibilities.to_a}"

    tile1_possibilities &= tile2_possibilities
  end

  tile1_possibilities
end

# Assemble image in layers of squares
#
#  123
#  223
#  333
(SIZE - 1).times do |layer|
  # Fill right side
  x = layer + 1
  (layer + 1).times do |y|
    left = (image[y] || [])[x - 1]
    above = (image[y - 1] || [])[x]

    possibilities = get_remaining_neighbor_tile(left, above, used_tiles)
    # puts "Putting #{possibilities.to_a[0]} at (#{x}, #{y})"
    image[y][x] = possibilities.to_a[0]
    used_tiles << image[y][x]
  end

  # Fill bottom side
  y = layer + 1
  (layer + 1).times do |x|
    left = (image[y] || [])[x - 1]
    above = (image[y - 1] || [])[x]

    possibilities = get_remaining_neighbor_tile(above, left, used_tiles)
    # puts "Putting #{possibilities.to_a[0]} at (#{x}, #{y})"
    image[y][x] = possibilities.to_a[0]
    used_tiles << image[y][x]
  end

  # Fill in corner
  # layer = 0, want above = (y: 0, x: 1), left: (y: 1, x: 0)
  n1 = image[layer][layer + 1]
  n2 = image[layer + 1][layer]

  possibilities = get_remaining_neighbor_tile(n1, n2, used_tiles)
  # puts "Putting #{possibilities.to_a[0]} at (#{layer + 1}, #{layer + 1})"
  image[layer + 1][layer + 1] = possibilities.to_a[0]
  used_tiles << image[layer + 1][layer + 1]
end

def rotate_tile_left(tile)
  width = tile[0].length
  height = tile.length
  new_tile = Array.new(width) {Array.new(height)}

  height.times do |y|
    width.times do |x|
      # top right: y:0, x:w to y:0, x: 0
      # top left: y:0, x:0 to y:w, x: 0
      # bottom left: y:h, x:0 to y:w, x:h
      # bottom right: y:h, x:w to y:0, x:h
      new_tile[width - 1 - x][y] = tile[y][x]
    end
  end

  new_tile.each_with_index do |row, i|
    new_tile[i] = row.join("")
  end

  new_tile
end

def flip_horizontal(tile)
  tile.map {|s| s.reverse}
end

# image.each do |row|
#   puts row.join("  ")
# end

oriented_tiles = Array.new(SIZE) {Array.new(SIZE)}
oriented_outer_tiles = Array.new(SIZE) {Array.new(SIZE)}

# My input
oriented_tiles[0][0] = rotate_tile_left($tile_nums_to_inner_tile[image[0][0]])
oriented_outer_tiles[0][0] = rotate_tile_left($tile_nums_to_outer_tile[image[0][0]])

# Ex1
# oriented_tiles[0][0] = rotate_tile_left(flip_horizontal($tile_nums_to_inner_tile[image[0][0]]))
# oriented_outer_tiles[0][0] = rotate_tile_left(flip_horizontal($tile_nums_to_outer_tile[image[0][0]]))

def put_inner_tile_num(tile_num)
  put_tile($tile_nums_to_inner_tile[tile_num])
end

def put_outer_tile_num(tile_num)
  put_tile($tile_nums_to_outer_tile[tile_num])
end

def put_tile(tile)
  tile.each {|s| puts s}
end

# put_tile(oriented_outer_tiles[0][0])
# 
# puts "****************"
# puts image[0][0]
# put_outer_tile_num(image[0][0])
# puts "****************"
# puts image[0][1]
# put_outer_tile_num(image[0][1])
# 
# puts "****************"


# Fill in top row
(SIZE - 1).times do |x|
  x = x + 1
  me = image[0][x]

  my_inner_tile = $tile_nums_to_inner_tile[me]
  my_outer_tile = $tile_nums_to_outer_tile[me]

  right_edge = oriented_outer_tiles[0][x-1].map(&:chars).map(&:last).join("")

  # puts "right edge: #{right_edge}"

  found_orientation = false
  [false, true].each do |should_flip|
    [0, 1, 2, 3].each do |rotate|
      # puts "flip?: #{should_flip}, times: #{rotate}"

      o_inner = my_inner_tile
      o_outer = my_outer_tile
      o_inner = flip_horizontal(o_inner) if should_flip
      o_outer = flip_horizontal(o_outer) if should_flip
      rotate.times do
        o_inner = rotate_tile_left(o_inner)
        o_outer = rotate_tile_left(o_outer)
      end

      left_edge = o_outer.map {|s| s[0]}.join("")

      # puts "left edge (of below): #{left_edge}"
      # puts '---'
      # put_tile(o_outer)
      # puts '---'

      if right_edge == left_edge
        oriented_tiles[0][x] = o_inner
        oriented_outer_tiles[0][x] = o_outer
        found_orientation = true
        # puts "found orientation!: rotate?: #{should_flip}, times: #{rotate}"
        break
      end
    end
    break if found_orientation
  end

  if !found_orientation
    puts "Didn't find orientation"
  end
end

# puts "FILLING IN ROWS BELOW"

(SIZE - 1).times do |y|
  y = y + 1
  SIZE.times do |x|
    me = image[y][x]

    # puts "TRYING TO orient y:#{y}, x:#{x}"

    my_inner_tile = $tile_nums_to_inner_tile[me]
    my_outer_tile = $tile_nums_to_outer_tile[me]

    bottom_edge = oriented_outer_tiles[y - 1][x].last

    # puts "bottom edge: #{bottom_edge}"

    found_orientation = false
    [false, true].each do |should_flip|
      [0, 1, 2, 3].each do |rotate|
        # puts "flip?: #{should_flip}, times: #{rotate}"

        o_inner = my_inner_tile
        o_outer = my_outer_tile
        o_inner = flip_horizontal(o_inner) if should_flip
        o_outer = flip_horizontal(o_outer) if should_flip
        rotate.times do
          o_inner = rotate_tile_left(o_inner)
          o_outer = rotate_tile_left(o_outer)
        end

        top_edge = o_outer[0]

        # puts "top edge (of above): #{top_edge}"
        # puts '---'
        # put_tile(o_outer)
        # puts '---'

        if bottom_edge == top_edge
          oriented_tiles[y][x] = o_inner
          oriented_outer_tiles[y][x] = o_outer
          found_orientation = true
          # puts "found orientation!: rotate?: #{should_flip}, times: #{rotate}"
          break
        end
      end
      break if found_orientation
    end

    if !found_orientation
      puts "Didn't find orientation"
    end
  end
end

def put_spaced_inner_tiles(tiles)
  SIZE.times do |outer_y|
    8.times do |inner_y|
      SIZE.times do |x|
        print tiles[outer_y][x][inner_y]
        print " "
      end
      puts
    end
    puts
  end
end

def put_spaced_outer_tiles(tiles)
  SIZE.times do |outer_y|
    10.times do |inner_y|
      SIZE.times do |x|
        print tiles[outer_y][x][inner_y]
        print " "
      end
      puts
    end
    puts
  end
end

# put_spaced_outer_tiles(oriented_outer_tiles)
# puts '**********'
# put_spaced_inner_tiles(oriented_tiles)


final_grid = []

SIZE.times do |outer_y|
  8.times do |inner_y|
    row = ""
    SIZE.times do |x|
      row += oriented_tiles[outer_y][x][inner_y]
    end
    final_grid << row
  end
end

# puts final_grid[0]
# puts final_grid.last


SEA_MONSTER = [
  "                  # ",
  "#    ##    ##    ###",
  " #  #  #  #  #  #   ",
]

# puts final_grid.length
# puts final_grid[0].length

is_sea_monster = Array.new(96) {Array.new(96) {false}}

# put_tile(final_grid)

[false, true].each do |should_flip|
  [0, 1, 2, 3].each do |rotate|
    sm = SEA_MONSTER
    sm = flip_horizontal(sm) if should_flip
    rotate.times {sm = rotate_tile_left(sm)}

    # puts "Looking for Sea Monster"
    # put_tile(sm)

    # Loop over every starting point
    (8 * SIZE).times do |start_x|
      (8 * SIZE).times do |start_y|
        found_sea_monster = true

        sm.length.times do |dy|
          sm[0].length.times do |dx|
            if sm[dy][dx] == '#'
              if (final_grid[start_y + dy] || [])[start_x + dx] != '#'
                found_sea_monster = false
                break
              end
            end
          end

          break if !found_sea_monster
        end

        if found_sea_monster
          # puts "Found sea monster at y:#{start_y}, x:#{start_x}"
          sm.length.times do |dy|
            sm[0].length.times do |dx|
              if sm[dy][dx] == '#'
                is_sea_monster[start_y + dy][start_x + dx] = true
              end
            end
          end
        end
      end
    end
  end
end

total_hash = final_grid.join("").chars.count {|ch| ch == '#'}
sea_monster_points = is_sea_monster.map {|ism_row| ism_row.count(&:itself)}.sum

puts "Part 2: #{total_hash - sea_monster_points}"