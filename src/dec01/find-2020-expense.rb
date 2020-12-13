require_relative '../aoc'

expenses = read_lines('input.txt').map(&:to_i)

qualifying_expense_amounts = [2, 3].map do |number_of_combinations|
  expenses.combination(number_of_combinations)
          .find([0]) { |a| a.reduce(:+) == 2020 }
          .reduce(:*)
end


puts qualifying_expense_amounts
