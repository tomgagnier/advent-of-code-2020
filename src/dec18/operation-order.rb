def lex(expression)
  expression.scan(/(\d+|[*+()])/).flatten
end

assert_equal(%w[1 + 2 * 3 + 4 * 5 + 6], lex("1 + 2 * 3 + 4 * 5 + 6"))
assert_equal(%w[1 + ( 2 * 3 ) + ( 4 * ( 5 + 6 ) )], lex("1 + (2 * 3) + (4 * (5 + 6))"))

def left_precedes_right(tokens, value = 0, op = :none)
  return value if tokens.empty?
  token = tokens.shift
  case token
  when '+'
    op = :+
  when '*'
    op = :*
  else
    operand = token.to_i
    value = op == :none ? operand : value.send(op, operand)
  end
  left_precedes_right(tokens, value, op)
end

assert_equal(71, left_precedes_right(%w[1 + 2 * 3 + 4 * 5 + 6]))

def add_precedes_multiply(tokens)
  loop do
    plus = (0...tokens.size).find { |i| tokens[i] == '+' }
    break if plus.nil?
    tokens[plus - 1] = left_precedes_right(tokens[plus - 1..plus + 1]).to_s
    tokens.slice!(plus, 2)
  end
  left_precedes_right(tokens)
end

assert_equal(231, add_precedes_multiply(%w[1 + 2 * 3 + 4 * 5 + 6]))

def evaluate(expression, precedence_strategy)
  tokens = lex(expression)
  loop do
    closed = (0...tokens.size).find { |i| tokens[i] == ')' }
    break if closed.nil?
    open = closed.downto(0).find { |i| tokens[i] == '(' }
    tokens[open] = method(precedence_strategy).call(tokens[open + 1...closed]).to_s
    tokens.slice!(open + 1, closed - open)
  end
  method(precedence_strategy).call(tokens)
end

assert_equal(71, evaluate("1 + 2 * 3 + 4 * 5 + 6", :left_precedes_right))
assert_equal(51, evaluate("1 + (2 * 3) + (4 * (5 + 6))", :left_precedes_right))
assert_equal(231, evaluate("1 + 2 * 3 + 4 * 5 + 6", :add_precedes_multiply))
assert_equal(51, evaluate("1 + (2 * 3) + (4 * (5 + 6))", :add_precedes_multiply))

expressions = File.readlines(file_path).map(&:strip).reject(&:empty?)

print "Part 1: "
p expressions.map { |expression| evaluate(expression, :left_precedes_right) }.reduce(:+)

print "Part 2: "
p expressions.map { |expression| evaluate(expression, :add_precedes_multiply) }.reduce(:+)
