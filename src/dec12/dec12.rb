def instructions(file)
  File.readlines(file)
      .map(&:strip)
      .reject(&:empty?)
      .map { |l| /^(.)(\d+)$/.match(l) }
      .map { |m| [m[1].to_sym, m[2].to_i] }
end

def manhattan(vectors)
  vectors
    .reduce([0, 0]) { |position, vector| [position[0] + vector[0], position[1] + vector[1]] }
    .map { |v| v.abs }.reduce(:+)
end

def part1(instructions)
  direction = 0
  vectors = instructions
              .map { |instruction, unit|
                case instruction
                when :E
                  [unit, 0]
                when :W
                  [-unit, 0]
                when :N
                  [0, unit]
                when :S
                  [0, -unit]
                when :L
                  direction += unit
                  [0, 0]
                when :R
                  direction -= unit
                  [0, 0]
                when :F
                  radians = direction * Math::PI / 180
                  [Math.cos(radians) * unit, Math.sin(radians) * unit]
                else
                  raise "unknown instruction #{instruction}"
                end
              }
  manhattan(vectors);
end

def rotate(degrees, point)
  radians = degrees * Math::PI / 180
  cos = Math.cos(radians)
  sin = Math.sin(radians)
  x, y = point
  [ x * cos - y * sin, y * cos + x * sin]
end

def part2(instructions)
  waypoint = [10, 1]
  position = [0, 0]
  instructions
    .each { |instruction, unit|
      case instruction
      when :E
        waypoint = [waypoint[0] + unit, waypoint[1]]
      when :W
        waypoint = [waypoint[0] - unit, waypoint[1]]
      when :N
        waypoint = [waypoint[0], waypoint[1] + unit]
      when :S
        waypoint = [waypoint[0], waypoint[1] - unit]
      when :L
        waypoint = rotate(unit, waypoint)
      when :R
        waypoint = rotate(-unit, waypoint)
      when :F
        position = [position[0] + unit * waypoint[0], position[1] + unit * waypoint[1]]
      else
        raise "unknown instruction #{instruction}"
      end
    }
  manhattan([position])
end

def evaluate(file)
  instructions = instructions(file)

  p part1(instructions)
  p part2(instructions)
end

evaluate('test-input.txt')
evaluate('input.txt')
