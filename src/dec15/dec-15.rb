def game(seq, limit)
  hash = Hash.new(0)
  seq[0..-2].each_with_index { |v, i| hash[v] = i + 1 }
  position = seq.size - 1
  value = seq[-1]
  until position == limit - 1
    position += 1
    previous_position = hash[value]
    hash[value] = position
    value = previous_position == 0 ? 0 : position - previous_position
  end
  value
end

p game([16,12,1,0,15,7,11], 2020)
p game([16,12,1,0,15,7,11], 30000000)
