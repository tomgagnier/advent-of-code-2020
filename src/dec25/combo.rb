require_relative '../aoc'

# Set the value to itself multiplied by the subject number.
# Set the value to the remainder after dividing the value by 20201227.
#
# 14897079
# The card transforms the subject number of 7 according to the card's secret loop size.
# The result is called the card's public key.
#
# The door transforms the subject number of 7 according to the door's secret loop size.
# The result is called the door's public key.
#
# The card and door use the wireless RFID signal to transmit the two public keys
# (your puzzle input) to the other device. Now, the card has the door's public key,
# and the door has the card's public key. Because you can eavesdrop on the signal,
# you have both public keys, but neither device's loop size.
#
# The card transforms the subject number of the door's public key according to
# the card's loop size. The result is the encryption key.
#
# The door transforms the subject number of the card's public key according to the
# door's loop size. The result is the same encryption key as the card calculated.

def handshake(value:, subject_number:)
  value * subject_number % 20201227
end

def find_loop_size(public_key:, value: 1, subject_number: 7)
  loop_size = 1
  loop do
    value = handshake(value: value, subject_number: subject_number)
    return loop_size if value == public_key
    loop_size += 1
  end
end

assert_equal(11, find_loop_size(17807724))
assert_equal(8, find_loop_size(5764801))

def find_encryption_key(public_key:, loop_size:)
  handshake(loop_size, public_key)
end

def evaluate(public_key_1, public_key_2)
  puts

  loop_size_1 = find_loop_size(public_key_1)
  puts "public_key_1 #{public_key_1} loop_size_1 #{loop_size_1}"

  loop_size_2 = find_loop_size(public_key_2)
  puts "public_key_2 #{public_key_2} loop_size_2 #{loop_size_2}"

  encryption_key_12 = find_encryption_key(public_key_1, loop_size_2)
  puts "encryption_key_12 #{encryption_key_12}"

  encryption_key_21 = find_encryption_key(public_key_2, loop_size_1)
  puts "encryption_key_21 #{encryption_key_21}"

  assert_equal(encryption_key_12, encryption_key_21)

  encryption_key_12
end

assert_equal(14897079, evaluate(5764801, 17807724))
#
# evaluate(1965712, 19072108)


