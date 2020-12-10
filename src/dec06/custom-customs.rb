##!/usr/bin/env ruby

groups = File.readlines('input.txt')
             .map { |line| line.chomp }
             .reduce([[]]) { |group, line| line.empty? ? group << [] : group[-1] << line; group }

p groups.map { |forms| forms.join.each_char.sort.uniq }
        .map { |unique_responses| unique_responses.size }
        .reduce(:+)

def to_char_freq(forms)
  forms.reduce(
    Hash.new(0)) { |freq, form| form.each_char { |c| freq[c] += 1; }; freq }
end

p groups.map { |forms| to_char_freq(forms).filter { |_, freq| freq == forms.size }.count }
        .reduce(:+)
