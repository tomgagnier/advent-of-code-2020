require_relative '../aoc'

def after(value)
  i = (0...cups.size).find { |i| cups[i] == value }
  (1...cups.size).map { |offset| (i + offset) % cups.size }
                 .map { |offset| cups[offset] }
                 .join

end

def play(count, input = '389125467')
  cups = input.chars.map(&:to_i)
  current = cups[0]
  count.times do |move|
    puts "-- move #{move + 1} --"
    puts "cups: #{cups.map { |cup| cup == current ? "(#{cup})" : "#{cup}" }.join(" ")}"
    position = (0...cups.size).find { |i| cups[i] == current }
    pick_up = (1..3).map { |i| (position + i) % cups.size }.map { |i| cups[i] }
    puts "pick up: #{pick_up.join(", ")}"
    candidates = (2..cups.size).map { |i| (current - i) % cups.size + 1 }
    cups = cups - pick_up
    destination = candidates.find { |candidate| cups.include?(candidate) }
    puts "destination: #{destination}"
    index = (0...cups.size).find { |i| cups[i] == destination }
    cups.insert((index + 1) % 9, *pick_up)
    current = cups[(position + 1) % cups.size]
  end
  cups
end

assert_equal([3, 8, 9, 1, 2, 5, 4, 6, 7], play(0))
assert_equal([3, 2, 8, 9, 1, 5, 4, 6, 7], play(1))
assert_equal([3, 2, 5, 4, 6, 7, 8, 9, 1], play(2))
assert_equal([7, 2, 5, 8, 9, 1, 3, 4, 6], play(3))
assert_equal([3, 2, 5, 8, 4, 6, 7, 9, 1], play(4))
assert_equal([9, 2, 5, 8, 4, 1, 3, 6, 7], play(5))
assert_equal([7, 2, 5, 8, 4, 1, 9, 3, 6], play(6))
assert_equal([8, 3, 6, 7, 4, 1, 9, 2, 5], play(7))
assert_equal([7, 4, 1, 5, 8, 3, 9, 2, 6], play(8))
assert_equal([5, 7, 4, 1, 8, 3, 9, 2, 6], play(9))
assert_equal([5, 8, 3, 7, 4, 1, 9, 2, 6], play(10))
