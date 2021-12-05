require_relative '../aoc'

def parse(file_path)
  group_lines_by_paragraphs(file_path).map { |paragraph| paragraph[1..-1].map(&:to_i) }
end

def award_top_cards(hands, winner_index)
  hands[winner_index] << hands[winner_index].shift << hands[1 - winner_index].shift
end

def score(hands)
  hands.reject(&:empty?)
       .map { |hand| hand.each_with_index.map { |v, i| (hand.size - i) * v }.reduce(:+) }
       .reduce(:+)
end

def play_part_1(hands)
  while hands.none? { |hand| hand.empty? }
    winner = hands[0][0] > hands[1][0] ? 0 : 1
    award_top_cards(hands, winner)
  end
  hands
end

def play_part_2(hands, history = [])
  while hands.none? { |hand| hand.empty? }
    hand_record = hands.to_s
    winner =
      if history.include?(hand_record)
        0
      else
        history << hand_record
        if hands[0][0] < hands[0].size && hands[1][0] < hands[1].size
          play_part_1([deep_copy(hands[0][1..hands[0][0]]),
                       deep_copy(hands[1][1..hands[1][0]])])[0].empty? ? 1 : 0
        else
          hands[0][0] > hands[1][0] ? 0 : 1
        end
      end
    award_top_cards(hands, winner)
  end
  hands
end

assert_equal(306, score(play_part_1(parse('test-input.txt'))))
assert_equal(32179, score(play_part_1(parse('input.txt'))))
assert_equal(291, score(play_part_2(parse('test-input2.txt'))))
# not 34555!
p score(play_part_2(parse('input.txt')))
