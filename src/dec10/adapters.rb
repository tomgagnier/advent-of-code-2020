require '../aoc'

def evaluate(file_path)

  adapters = read_integers(file_path).sort
  voltages = [0] + adapters << adapters[-1] + 3

  freq = voltages[0..-2]
           .zip(voltages[1..-1])
           .map { |a, b| b - a }
           .reduce(Hash.new(0)) { |h, d| h[d] = h[d] + 1; h }

  p freq[1] * freq[3]

  # See dynamic programming and memoization
  memo = Array.new(voltages.size, 0)
  memo[0] = 1
  (0..memo.size - 1).each do |i|
    (i + 1...[i + 4, memo.size].min).each do |j|
      memo[j] += memo[i] if voltages[j] - voltages[i] <= 3
    end
  end

  p memo[-1]
end

%w(test-input.txt test-input2.txt input.txt).each do |file_path|
  puts "\n#{file_path}"
  evaluate(file_path)
end
