def game(seq, limit)
  position = seq.size
  value = seq.pop
  positions_by_value = seq.each_with_index.to_h { |v, i| [v, i + 1] }
  until position == limit
    previous_position = positions_by_value.has_key?(value) ? positions_by_value[value] : position
    positions_by_value[value] = position
    value = position - previous_position
    position += 1
  end
  value
end

p game([16, 12, 1, 0, 15, 7, 11], 2020)
p game([16,12,1,0,15,7,11], 30000000)
