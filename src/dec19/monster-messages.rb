require_relative '../aoc'

def tokenize(rule_list)
  rule_list.map do |r|
    m = /(?<name>\d+): "?(?<rule>[^"]+)"?/.match(r)
    tokens = m[:rule].split
    tokens = ['('] + tokens + [')'] if tokens.size > 1
    [m[:name], tokens]
  end.to_h
end

def partition_by_resolved(rules)
  rules.partition { |_, tokens| tokens.none? { |token| rules.has_key?(token) } }
       .map { |kv_pairs| kv_pairs.to_h }
end

def compile(rules)
  number_resolved = -1

  loop do
    resolved, unresolved = partition_by_resolved(rules)
    break if resolved.size == number_resolved
    number_resolved = resolved.size
    unresolved.each do |name, tokens|
      recursive = rules[name].each_with_index.find { |v, i| v == name }
      if recursive
        v, i = recursive
        tokens[i] = "\\g<_#{name}>"
        tokens = ["(?<_#{name}>"] + tokens + [')']
      end
      rules[name] = tokens.map do |token|
        if resolved.has_key?(token)
          resolved[token].join
        else
          token
        end
      end
    end
  end
  rules.map { |name, rule| [name, Regexp.new('^' + rule.join + '$')] }.to_h
end

def evaluate(file_path, updates = [])
  rule_sources, messages = group_lines_by_paragraphs(file_path)
  rule_tokens = tokenize(rule_sources).merge(tokenize(updates))
  rules = compile(rule_tokens)
  messages.filter { |message| rules['0'].match?(message) }.size
end

assert_equal(2, evaluate('test-input.txt'))
assert_equal(113, evaluate('input.txt'))
assert_equal(3, evaluate('test-input2.txt'))
assert_equal(12, evaluate('test-input2.txt', ["8: 42 | 42 8", "11: 42 31 | 42 11 31"]))
assert_equal(253, evaluate('input.txt', ["8: 42 | 42 8", "11: 42 31 | 42 11 31"]))
