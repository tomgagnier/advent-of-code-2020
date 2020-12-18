require_relative '../aoc'

def evaluate(file, preamble)
  seq = read_lines(file).map(&:to_i)

  invalid = (preamble...seq.size)
              .map { |i| [seq[i], seq[i - preamble..i].combination(2)
                                                      .map { |a, b| a + b }] }
              .reject { |val, sums| sums.include?(val) }[0][0]

  weak = (0...seq.size)
           .map { |i| (i + 1...seq.size).map { |k| seq[i..k] }.find { |s| s.reduce(:+) == invalid } }
           .find { |s| s }

  puts invalid, weak.min + weak.max
end

evaluate('test-input.txt', 5)
evaluate('input.txt', 25)
