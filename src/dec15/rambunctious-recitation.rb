def game(sequence:, limit:)
  position = sequence.size
  value = sequence.pop
  last_positions = sequence.each_with_index.to_h { |v, i| [v, i + 1] }
  until position == limit
    last_position = last_positions.has_key?(value) ? last_positions[value] : position
    last_positions[value] = position
    value = position - last_position
    position += 1
  end
  value
end

p game(sequence: [16, 12, 1, 0, 15, 7, 11], limit: 2020)
p game(sequence: [16, 12, 1, 0, 15, 7, 11], limit: 30000000)
