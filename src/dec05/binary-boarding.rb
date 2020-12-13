require_relative '../aoc'

seat_ids = read_lines('input.txt')
             .map { |partition_code| /(?<row>[FB]*)(?<column>[LR]*)/.match(partition_code) }
             .map { |match| 8 *
               binary_code_to_i(code: match[:row], zero_char: 'F') +
               binary_code_to_i(code: match[:column], zero_char: 'L') }
             .sort

puts "Maximum Seat ID: #{seat_ids[-1]}"

puts "Empty Seat ID: #{seat_ids[0..-2].zip(seat_ids[1..-1]).find { |id0, id1| id1 - id0 != 1 }[0] + 1}"
