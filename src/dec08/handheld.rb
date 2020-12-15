require '../aoc'

def read_stack(file_path)
  def evaluate(pos = 0, acc = 0, visited = [])
    return [acc, pos >= size] if pos >= size || visited.include?(pos)
    visited << pos
    case itself[pos][0]
    when :acc
      acc += itself[pos][1]
      pos += 1
    when :jmp
      pos += itself[pos][1]
    else
      pos += 1
    end
    evaluate(pos, acc, visited)
  end

  def swap(pos)
    if itself[pos][0] == :jmp
      itself[pos][0] = :nop
    elsif itself[pos][0] == :nop
      itself[pos][0] = :jmp
    end
  end

  def patch(pos)
    swap(pos)
    result = evaluate
    swap(pos)
    result
  end

  read_lines(file_path)
    .map { |l| l.split(' ') }
    .map { |instruction, scalar| [instruction.to_sym, scalar.to_i] }
end

for file_path in %w(test-input.txt input.txt)
  stack = read_stack(file_path)
  p stack.part_1
  p (0...stack.size)
      .map { |pos| stack.patch(pos) }
      .find { |_, terminates| terminates }
end
