mod dec05;

use std::fs::File;
use std::io;
use std::io::BufRead;
use std::path::Path;

/// Returns a line iterator result
fn read_lines<P>(path: P) -> io::Result<io::Lines<io::BufReader<File>>>
where
    P: AsRef<Path>,
{
    let file = File::open(path)?;
    Ok(io::BufReader::new(file).lines())
}

/// Returns a vector of strings read from the file at the path.
/// Naively panics if unable to open or read file.
fn lines_of<P>(path: P) -> Vec<String>
where
    P: AsRef<Path>,
{
    match read_lines(path) {
        Ok(lines) => lines
            .map(|l| l.unwrap_or_else(|e| panic!("Unable to read line: {:?}", e)))
            .collect(),
        Err(e) => panic!("Unable to open file: {:?}", e),
    }
}

#[cfg(test)]
mod tests {
    use crate::*;

    #[test]
    fn read_lines_when_file_exists() {
        match read_lines("README.md") {
            Ok(mut lines) => match lines.next() {
                None => panic!("Expected first line to exist"),
                Some(line) => assert_eq!("Advent of Code 2020", line.unwrap()),
            },
            Err(e) => panic!("README.md expected to exist {}", e),
        }
    }

    #[test]
    fn test_lines() {
        let lines = lines_of("README.md");
        assert_eq!("Advent of Code 2020", lines[0]);
    }
}
