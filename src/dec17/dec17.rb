require_relative '../aoc'

class Cube
  include Enumerable

  attr :active

  def initialize(file_path)
    @active = []
    read_lines(file_path).each_with_index do |l, j|
      l.each_char.each_with_index do |c, i|
        if c == '#'
          @active << [i, j, 0]
        end
      end
    end
  end

  def to_s
    s = ''
    (min_z..max_z).each do |z|
      s += "\nz = #{z}\n"
      (min_y..max_y).each do |y|
        (min_x..max_x).each do |x|
          active?([x, y, z]) ? s += '#' : s += '.'
        end
        s += "\n"
      end
    end
    s
  end

  def min_x
    active.map { |o| o[0] }.min
  end

  def max_x
    active.map { |o| o[0] }.max
  end

  def min_y
    active.map { |o| o[1] }.min
  end

  def max_y
    active.map { |o| o[1] }.max
  end

  def min_z
    active.map { |o| o[2] }.min
  end

  def max_z
    active.map { |o| o[2] }.max
  end

  def active?(xyz)
    active.any? { |o| o == xyz }
  end

  def neighbors(xyz)
    (-1..1).flat_map { |dx| (-1..1).flat_map { |dy| (-1..1).map { |dz| [xyz[0] + dx, xyz[1] + dy, xyz[2] + dz] } } } - [xyz]
  end

  # If a cube is active and exactly 2 or 3 of its neighbors are also active,
  # the cube remains active. Otherwise, the cube becomes inactive.
  # If a cube is inactive but exactly 3 of its neighbors are active,
  # the cube becomes active. Otherwise, the cube remains inactive.
  def next_active?(xyz)
    count = neighbors(xyz).filter { |neighbor| active?(neighbor) }.count
    active?(xyz) ? count.between?(2, 3) : count == 3
  end

  def each(&block)
    loop do
      block.call(itself)
      next_active = (min_x - 1..max_x + 1)
        .flat_map { |x| (min_y - 1..max_y + 1)
          .flat_map { |y| (min_z - 1..max_z + 1)
            .map { |z| [x, y, z] } } }
        .filter { |xyz| next_active?(xyz) }
      @active = next_active
    end
  end

end

cube = Cube.new('input.txt')
cube.take(7)
p cube.active.size
