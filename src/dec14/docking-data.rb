require_relative '../aoc'

def to_bits(mask, &is_bit_set)
  mask.each_char.map { |c| is_bit_set.call(c) ? 1 : 0 }.join.to_i(2)
end

def evaluate(instructions, new_update_lambda, offset = 0, registers = {}, update_registers = lambda {})
  return registers.values.reduce(:+) if offset == instructions.size
  line = instructions[offset]
  if line =~ /^mask = (.*)$/
    mask = Regexp.last_match[1]
    update_registers = new_update_lambda.call(registers, mask)
  elsif line =~ /^mem\[(\d+)\] = (\d+)$/
    mem = Regexp.last_match[1].to_i
    val = Regexp.last_match[2].to_i
    update_registers.call(mem, val)
  end
  evaluate(instructions, new_update_lambda, offset + 1, registers, update_registers)
end

part_1_register_update = lambda do |registers, mask|
  lambda do |mem, val|
    registers[mem] = val &
      to_bits(mask) { |c| c != '0' } |
      to_bits(mask) { |c| c == '1' }
  end
end

part_2_register_update = lambda do |registers, mask|
  lambda do |mem, val|
    mask_1 = to_bits(mask) { |c| c == '1' }
    mask_f = to_bits(mask) { |c| c == 'X' }
    address = (mem | mask_1) & ~mask_f
    bitmasks = mask.enum_for(:scan, /X/)
                   .map { 1 << (mask.length - Regexp.last_match.begin(0) - 1) }
    [0, 1].repeated_permutation(bitmasks.size)
          .map { |bitarray| bitarray.zip(bitmasks) }
          .map { |l| l.map { |e| e[0] * e[1] }.reduce(:+) }
          .each { |m| registers[m | address] = val }
  end
end

instructions = read_lines('input.txt')
p evaluate(instructions, part_1_register_update)
p evaluate(instructions, part_2_register_update)
  