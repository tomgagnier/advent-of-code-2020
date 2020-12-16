require_relative '../aoc'

Field = Struct.new(:name, :range1, :range2) do
  def include?(number)
    range1.include?(number) or range2.include?(number)
  end
end

def parse(file_path)
  paragraphs = group_lines_by_paragraphs(file_path)

  fields = paragraphs[0].map do |r|
    m = /([^:]+): *(\d+)-(\d+) or (\d+)-(\d+)/.match(r)
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

  valid_tickets = nearby_tickets
    .filter { |t| t.all? { |n| fields.any? { |f| f.include? n } } }

  possible_field_names = valid_tickets
    .map { |t| t.map { |n| fields.filter { |f| f.include?(n) }.map { |f| f.name } } }

  position_name_lists = Array.new(fields.size, fields.map { |f| f.name })

  possible_field_names.each do |list_of_list_of_names|
    list_of_list_of_names.each_with_index do |list_of_names, i|
      position_name_lists[i] &= list_of_names
    end
  end

  loop do
    singletons, multiples = position_name_lists
      .each_with_index
      .partition { |names, _| names.size == 1 }
    break if multiples.size == 0
    singletons.map! { |name, _| name[0] }.flatten
    multiples.each { |_, i| position_name_lists[i] -= singletons }
  end

  position_name_lists.flatten
    .zip(your_ticket)
    .filter { |name, _| name.start_with?("departure") }
    .map { |_, number| number }
    .reduce(:*)
end

p part_1('input-test.txt')
p part_1('input.txt')
p part_2('input.txt')
