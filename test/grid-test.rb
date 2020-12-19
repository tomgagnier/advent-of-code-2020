require_relative '../src/aoc'

GRID_4_BY_5 = <<~EOF
  1234
  abcd
  ABCD
  wxyz
  WXYZ
EOF

grid = Grid.from_string(GRID_4_BY_5)

assert_equal(3, grid.max_i)
assert_equal(4, grid.max_j)

assert_equal('W', grid[0][0])
assert_equal('X', grid[1][0])
assert_equal('4', grid[3][4])

assert_equal(GRID_4_BY_5.chomp, grid.to_s)


