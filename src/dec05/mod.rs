fn to_i<S: AsRef<str>>(binary_code: S, zero: char) -> u8 {
    binary_code.chars();
        // .iter().rev().enumerate()
        // .map(|i, c| (if c == zero { 0 } else { 1 }) << i)
        // .sum()
    0
}

#[cfg(test)]
mod tests {
    use crate::lines_of;
    use crate::dec05::*;

    #[test]
    fn test_to_i() {
        let i = to_i("BFFFBBF", 'F');
        println!("{:?}", i);
    }

    #[test]
    fn part_1() {
        let lines = lines_of("src/dec05/test-input.txt");

        println!("{:?}", lines)
    }
}
