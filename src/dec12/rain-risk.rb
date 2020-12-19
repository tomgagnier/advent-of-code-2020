def instructions(file)
  File.readlines(file)
      .map(&:strip)
      .reject(&:empty?)
      .map { |l| /^(.)(\d+)$/.match(l) }
      .map { |m| [m[1].to_sym, m[2].to_i] }
end

def manhattan(position)
  position.map { |v| v.abs }.reduce(:+).truncate
end

def part1(instructions, direction = 0, position = [0, 0])
  return manhattan(position) if instructions.empty?
  instruction, unit = instructions.shift
  case instruction
  when :E
    position[0] += unit
  when :W
    position[0] -= unit
  when :N
    position[1] += unit
  when :S
    position[1] -= unit
  when :L
    direction += unit
  when :R
    direction -= unit
  when :F
    radians = direction * Math::PI / 180
    position[0] += Math.cos(radians) * unit
    position[1] += Math.sin(radians) * unit
  else
    raise "unknown instruction #{instruction}"
  end
  part1(instructions, direction, position)
end

def rotate(degrees, point)
  radians = degrees * Math::PI / 180
  cos = Math.cos(radians)
  sin = Math.sin(radians)
  x, y = point
  [x * cos - y * sin, y * cos + x * sin]
end

def part2(instructions, waypoint = [10, 1], position = [0, 0])
  return manhattan(position) if instructions.empty?
  instruction, unit = instructions.shift
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
  part2(instructions, waypoint, position)
end

def evaluate(file)
  p part1(instructions(file))
  p part2(instructions(file))
end

evaluate('test-input.txt')
evaluate('input.txt')
