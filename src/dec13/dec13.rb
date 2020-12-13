require_relative '../aoc'

#############################################################
# https://rosettacode.org/wiki/Chinese_remainder_theorem#Ruby

module ChineseRemainderTheorem

  extend self

  def solve(moduli, remainders)
    max_lcd = moduli.reduce(:*) # least common multiple
    series = remainders
               .zip(moduli)
               .map { |r, m| r * max_lcd * inverse_mod(max_lcd / m, m) / m }
    series.reduce(:+) % max_lcd
  end

  def inverse_mod(e, et)
    g, x = extended_gcd(e, et)
    raise 'Multiplicative inverse modulo does not exist!' if g != 1
    x % et
  end

  def extended_gcd(a, b)
    last_remainder, remainder = a.abs, b.abs
    x, last_x = 0, 1
    y, last_y = 1, 0
    while remainder != 0
      # Computations on the right are performed before assignment,
      # implicitly creating temporary swap space
      last_remainder, (quotient, remainder) = remainder, last_remainder.divmod(remainder)
      x, last_x = last_x - quotient * x, x
      y, last_y = last_y - quotient * y, y
    end
    [last_remainder, last_x * (a < 0 ? -1 : 1)]
  end
end

#############################################################
#

def part_1(lines)
  t0 = lines[0].to_i
  ids = lines[1].split(',')
                .reject { |id| id == 'x' }
                .map { |id| id.to_i }

  p ids.map { |id| [id, id * (t0 / id) + id] }
       .sort_by { |_, t| t }
       .map { |id, t| id * (t - t0) }[0]
end

def part_2(lines)
  moduli, remainders = lines.split(',')
                            .each_with_index
                            .reject { |m, _| m == 'x' }
                            .map { |m, r| [m.to_i, -r] }
                            .transpose
  p ChineseRemainderTheorem.solve(moduli, remainders)
end

p ChineseRemainderTheorem.extended_gcd(30, 90)
# 295
# 1068781
# 2238
# 560214575859998
# %w(test-input.txt input.txt).each do |file_path|
#   lines = read_lines(file_path)
#   part_1(lines)
#   part_2(lines[1])
# end
