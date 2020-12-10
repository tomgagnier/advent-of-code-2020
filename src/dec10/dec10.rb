def evaluate(file)

  def adapter_zip(a)
    ([0] + a[0..-1]).zip(a << a[-1] + 3)
  end

  adapters = [0] + File.readlines(file).map(&:strip).reject(&:empty?).map(&:to_i).sort
  adapters << adapters[-1] + 3

  freq = adapters[0..-2].zip(adapters[1..-1])
                        .map { |a, b| b - a }
                        .reduce(Hash.new(0)) { |h, d| h[d] = h[d] + 1; h }

  puts
  p file
  p freq[1] * freq[3]

  # See dynamic programming and memoization
  memo = Array.new(adapters.size, 0)
  memo[0] = 1

  (0..memo.size - 1).each do |i|
    (i + 1...[i + 4, memo.size].min).each do |j|
      memo[j] += memo[i] if adapters[j] - adapters[i] <= 3
    end
  end

  p memo[-1]

end

evaluate('test-input.txt')
evaluate('test-input2.txt')
evaluate('input.txt')
