require 'ostruct'

class Passport < OpenStruct
  def required_fields?
    ([:ecl, :pid, :eyr, :hcl, :byr, :iyr, :hgt] - to_h.keys).empty?
  end

  def valid_year?(year, min, max)
    year =~ /^\d+$/ && year.to_i.between?(min, max)
  end

  def valid_height?
    match = /^(?<height>\d+)(?<unit>cm|in)$/.match(hgt)
    return false unless match
    height = match[:height].to_i
    (match[:unit] == 'cm') ? height.between?(150, 193) : height.between?(59, 76)
  end

  def valid?
    required_fields? &&
      valid_year?(byr, 1920, 2002) &&
      valid_year?(iyr, 2010, 2020) &&
      valid_year?(eyr, 2020, 2030) &&
      valid_height? &&
      hcl =~ /^#[0-9a-f]{6}$/ &&
      ecl =~ /^(amb|blu|brn|gry|grn|hzl|oth)$/ &&
      pid =~ /^\d{9}$/
  end
end

passports = File.readlines('input.txt')
                .map { |l| l.chomp.split(/ +/).map { |kv| kv.split(/ *: */) }.to_h }
                .reduce([{}]) { |a, h| a[-1] = a[-1].merge(h); a << {} if h.empty?; a }
                .map { |h| Passport.new(h) }

puts "part 0: #{passports.count}"
puts "part 1: #{passports.filter { |p| p.required_fields? }.count}"
puts "part 2: #{passports.filter { |p| p.valid? }.count}"
