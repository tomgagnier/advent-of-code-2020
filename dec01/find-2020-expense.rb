#!/usr/bin/env ruby

expenses = File.readlines('input.txt').map(&:to_i)

output = [2, 3].map do |number_of_combinations|
  expenses.combination(number_of_combinations)
          .find([0]) { |a| a.reduce(:+) == 2020 }
          .reduce(:*)
end

puts output
