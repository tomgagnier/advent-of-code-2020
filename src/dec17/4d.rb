require '../aoc'

def next_active(active)
  ranges = active.transpose.map { |c| [c.min - 1, c.max + 1] }.map { |min, max| (min..max) }
  next_active = []
  ranges[0].each { |x|
    ranges[1].each { |y|
      ranges[2].each { |z|
        ranges[3].each { |w|
          point = [x, y, z, w]
          neighborhood =
            (-1..1).flat_map { |dx|
              (-1..1).flat_map { |dy|
                (-1..1).flat_map { |dz|
                  (-1..1).map { |dw| [x + dx, y + dy, z + dz, w + dw] } } } }
          count = neighborhood.size - (neighborhood - active).size
          if active.include?(point)
            if count.between?(3, 4)
              next_active << point
            end
          else
            if count == 3
              next_active << point
            end
          end
        }
      }
    }
  }
  next_active
end

active = read_lines('input.txt').each_with_index.flat_map { |line, y|
  line.each_char.each_with_index
      .filter { |c, _| c == '#' }
      .map { |c, x| [x, y, 0, 0] } }

p active.count
(1..6).each do
  active = next_active(active)
  p active.count
end
