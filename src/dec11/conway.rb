require '../aoc'

class Layout
  def initialize(grid)
    @grid = grid
  end

  def self.read(file_path)
    Layout.new(read_lines(file_path).map(&:each_char).map(&:to_a))
  end

  def ==(o)
    to_s == o.to_s
  end

  def to_s
    @grid.map { |r| r.join }.join("\n")
  end

  def max_i
    @grid[0].size - 1
  end

  def max_j
    @grid.size - 1
  end

  def at(position)
    i, j = position
    @grid[j][i]
  end

  def adjacent_to(position)
    i, j = position
    [[i - 1, j - 1], [i - 1, j], [i - 1, j + 1], [i, j - 1],
     [i, j + 1], [i + 1, j - 1], [i + 1, j], [i + 1, j + 1]]
      .filter { |x, y| x.between?(0, max_i) && y.between?(0, max_j) }
  end

  def directions_from(position)
    i0, j0 = position
    { north: (0...j0).reverse_each.map { |j| [i0, j] },
      north_east: (1..[max_i - i0, j0].min).map { |offset| [i0 + offset, j0 - offset] },
      east: ((i0 + 1)..max_i).map { |i| [i, j0] },
      south_east: (1..[max_i - i0, max_j - j0].min).map { |offset| [i0 + offset, j0 + offset] },
      south: ((j0 + 1)..max_j).map { |j| [i0, j] },
      south_west: (1..[i0, max_j - j0].min).map { |offset| [i0 - offset, j0 + offset] },
      west: (0...i0).reverse_each.map { |i| [i, j0] },
      north_west: (1..[i0, j0].min).map { |offset| [i0 - offset, j0 - offset] } }
  end

  def descendents(&update_position)
    collect_descendents(itself, [], update_position)
  end

  private

  def collect_descendents(layout, layouts, update_position)
    return layouts if layouts.include?(layout)
    layouts << layout
    new_grid = Array.new(max_j + 1) { Array.new(max_i + 1) }
    (0..max_j).map do |j|
      (0..max_i).map do |i|
        new_grid[j][i] = update_position.call(layout, [i, j])
      end
    end
    collect_descendents(Layout.new(new_grid), layouts, update_position)
  end

end

def evaluate(file)
  layout = Layout.read(file)

  generations = layout.descendents do |l, position|
    status = l.at(position)
    if status == '.'
      status
    else
      adjacent = l.adjacent_to(position)
      count = adjacent.map { |p| l.at(p) }.filter { |s| '#' == s }.count
      if '#' == status && count >= 4
        'L'
      elsif 'L' == status && count == 0
        '#'
      else
        status
      end
    end
  end

  p generations[-1].to_s.each_char.filter { |p| p == '#' }.count

  generations = layout.descendents do |l, position|
    status = l.at(position)
    if status == '.'
      status
    else
      count = l.directions_from(position)
               .values
               .map { |positions| positions.map { |p| l.at(p) }.reject { |s| s == '.' } }
               .reject(&:empty?)
               .map { |positions| positions[0] == '#' ? 1 : 0 }
               .reduce(:+)
      if '#' == status && count >= 5
        'L'
      elsif 'L' == status && count == 0
        '#'
      else
        status
      end
    end
  end

  p generations[-1].to_s.each_char.filter { |p| p == '#' }.count
end

evaluate('test-input.txt')
evaluate('input.txt')


