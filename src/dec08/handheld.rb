def read_stack(file)
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

  File.readlines(file)
      .map { |l| l.strip.split(' ') }
      .map { |instruction, scalar| [instruction.to_sym, scalar.to_i] }
end

stack = read_stack('input.txt')
p stack.evaluate
p (0...stack.size).map { |pos| stack.patch(pos) }.find{|_, terminates| terminates}
