def to_i(binary_code, zero_char)
  binary_code.each_char.map { |c| c == zero_char ? 0 : 1 }.join.to_i(2)
end

seat_ids = File.readlines('input.txt')
               .map { |partition_code| /(?<row>[FB]*)(?<column>[LR]*)/.match(partition_code) }
               .map { |match| 8 * to_i(match[:row], 'F') + to_i(match[:column], 'L') }
               .sort

puts "Maximum Seat ID: #{seat_ids[-1]}"

puts "Empty Seat ID: #{seat_ids[0..-2].zip(seat_ids[1..-1]).find { |id0, id1| id1 - id0 != 1 }[0] + 1}"
