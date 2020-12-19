require_relative '../aoc'

Field = Struct.new(:name, :range1, :range2) do
  def include?(number)
    range1.include?(number) or range2.include?(number)
  end
end

def parse(file_path)
  paragraphs = group_lines_by_paragraphs(file_path)

  fields = paragraphs[0].map do |field_definition|
    m = /([^:]+): *(\d+)-(\d+) or (\d+)-(\d+)/.match(field_definition)
    name = m[1]
    range1 = (m[2].to_i..m[3].to_i)
    range2 = (m[4].to_i..m[5].to_i)
    Field.new(name, range1, range2)
  end

  your_ticket = paragraphs[1][1].split(/,/).map { |s| s.to_i }

  nearby_tickets = paragraphs[2][1..-1].map { |l| l.split(/,/).map { |s| s.to_i } }

  [fields, nearby_tickets, your_ticket]
end

def part_1(file_path)
  fields, nearby_tickets, _ = parse(file_path)

  nearby_tickets
    .flatten
    .filter { |n| fields.none? { |f| f.include?(n) } }
    .reduce(:+)
end

def part_2(file_path)

  fields, nearby_tickets, your_ticket = parse(file_path)

  position_names = nearby_tickets
    .filter { |numbers| numbers.all? { |n| fields.any? { |f| f.include? n } } }
    .map { |numbers| numbers.map { |n| fields.filter { |f| f.include?(n) }.map { |f| f.name } } }
    .transpose
    .map { |columns| columns.reduce(fields.map { |f| f.name }) { |names, column| names & column } }

  loop do
    resolved = position_names
      .filter { |names| names.size == 1 }
      .flatten
    break if resolved.size == position_names.size
    position_names
      .map! { |names| names.size == 1 ? names : names - resolved }
  end

  position_names
    .flatten
    .zip(your_ticket)
    .filter { |name, _| name.start_with?("departure") }
    .map { |_, number| number }
    .reduce(:*)
end

p part_1('input-test.txt')
p part_1('input.txt')
p part_2('input.txt')
