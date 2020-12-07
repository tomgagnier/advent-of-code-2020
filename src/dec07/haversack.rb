##!/usr/bin/env ruby

def read_bags(file)
  def to_symbol(s)
    s.strip.gsub(' ', '_').to_sym
  end

  def to_array_of_symbols(nested_bags)
    return [] if nested_bags == 'no other bags.'
    nested_bags.split(', ')
               .map { |s| /(?<count>\d+)\s+(?<bag_type>.*) bag/.match(s) }
               .map { |m| Array.new(m[:count].to_i, to_symbol(m[:bag_type])) }
               .flatten
  end

  def walk(bag)
    Enumerator.new do |enum|
      unvisited = itself[bag].clone
      until unvisited.empty?
        visited = unvisited.shift
        enum.yield visited
        unvisited += itself[visited]
      end
    end
  end

  File.readlines(file)
      .map { |l| l.strip.split(" bags contain ") }
      .map { |m| [to_symbol(m[0]), to_array_of_symbols(m[1])] }
      .to_h
end

bags = read_bags('test-input.txt')

p bags.keys.map { |bag| bags.walk(bag).find { |b| b == :shiny_gold } }.count

p bags.walk(:shiny_gold).count
