#!/usr/bin/env ruby

matches = File.readlines('input.txt')
              .map { |line| /(?<i>\d+)-(?<j>\d+) (?<character>.): (?<password>.*)/.match(line) }

count = matches.count do |m|
  min = m[:i].to_i
  max = m[:j].to_i
  m[:password].count(m[:character]).between?(min, max)
end

puts count

count = (matches.count do |m|
  i = m[:i].to_i - 1
  j = m[:j].to_i - 1
  (m[:password][i] == m[:character]) ^ (m[:password][j] == m[:character])
end)

puts count