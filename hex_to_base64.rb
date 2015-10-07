# Convert hex to base64
# The string:

# 49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d
# Should produce:

# SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t
# So go ahead and make that happen. You'll need to use this code for the rest of the exercises.

# Cryptopals Rule
# Always operate on raw bytes, never on encoded strings. Only use hex and base64 for pretty-printing.


if __FILE__ == $0
  puts `rspec -f documentation #{__FILE__}`
else
  require "rspec"
end

describe :hex_to_base64 do
  HEX_STRING = '49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d'
  BASE64_STRING = 'SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t'

  it "converts #{HEX_STRING} to #{BASE64_STRING}" do
    expect(hex_to_base64(HEX_STRING)).to eq(BASE64_STRING)
  end

  it "checks against ruby's own pack/unpack" do
    [HEX_STRING].pack("H*").unpack("m").first == BASE64_STRING
  end
end

# I've never actually implemented base64, but rather than look it up, let's
# have some fun and see if we can figure it out from what we're given.
#
# 11:15, restate my assumptions:
# 1. hex digits encode 4 bits (2**4 == 16)
# 2. base64 digits encode 6 bits (2**6 == 64)
#
# So, according to the example, hex "492" == base64 "SS"
#    4   9   2
# 010010010010
#      S     S
# This implies 'S' is 0b010010 or 18, implying 'A' is the first digit;
# assume A..Z are digits 0..25 in base64
# What about the rest?
#
# Look at an example that has lowercase in the base64: hex "76d" == base64 "dt"
#    7   6   d
# 011101101101
#      d     t
# So 'd' is 0b011101 or 29 in base64;
# assume 'a' is 26 and a..z are digits 26..51 in base64
# Presumably 0-9 are digits 52..62, but let's check:
#
# (from the end) hex "f6d" == base64 "9t"
#    f   6   d
# 111101101101
#      9     t
# t is 26 + ("t".ord - "a".ord) == 45 in base64, which matches 0b101101
# '9' is 0b111101 or 61, verifying that 0..9 are digits 51..61
# But, we're still 2 digits short. The example doesn't contain either of them.
#
# Research shows the last two digits vary, but the most common seems to be '+', '/'
def hex_to_base64(hex_string)
  bytes_to_base64(hex_to_bytes(hex_string))
end

describe :hex_to_bytes do
  it "returns an empty array for an empty string" do
    expect(hex_to_bytes('')).to eq([])
  end

  it "handles odd length strings" do
    expect(hex_to_bytes('F')).to eq([0xF])
    expect(hex_to_bytes('A07')).to eq([0xA, 0x07])
  end

  it "handles both upper and lowercase hex" do
    expect(hex_to_bytes('f00d')).to eq([0xf0, 0x0d])
    expect(hex_to_bytes('F00D')).to eq([0xf0, 0x0d])
  end

  it "gives an error on invalid input" do
    expect { hex_to_bytes('beefcake') }.to raise_error(ArgumentError)
  end

  { '492' => [0x4, 0x92],
    '76d' => [0x7, 0x6d],
    'f6d' => [0xf, 0x6d]
  }.each do |input, output|
    it "converts #{input.inspect} to #{output.inspect}" do
      expect(hex_to_bytes(input)).to eq(output)
    end
  end
end

def hex_to_bytes(hex_string)
  hex_string = "0#{hex_string}" if hex_string.length.odd?
  hex_string.scan(/../).map {|hex_byte| Integer(hex_byte, 16) }
end

describe :bytes_to_base64 do
  it "returns an empty string for an empty array" do
    expect(bytes_to_base64([])).to eq("")
  end

  it "gives an error on invalid input" do
    expect { bytes_to_base64([2**8]) }.to raise_error(ArgumentError)
  end

  it "trims leading zeroes" do
    expect(bytes_to_base64([0] * 5)).to eq("A")
    expect(bytes_to_base64([0, 1])).to eq("B")
    expect(bytes_to_base64([0, 0, 1, 0, 0, 1])).to eq("BAAAB")
  end

  { [0x4, 0x92] => 'SS',
    [0x7, 0x6d] => 'dt',
    [0xf, 0x6d] => '9t'
  }.each do |input, output|
    it "converts #{input.inspect} to #{output.inspect}" do
      expect(bytes_to_base64(input)).to eq(output)
    end
  end
end

BYTE_RANGE = 0..255
B64_DIGITS = ("A".."Z").to_a + ("a".."z").to_a + ("0".."9").to_a + ['+', '/']
BITS_PER_B64_DIGIT = 6
B64_DIGIT_MASK = 2**BITS_PER_B64_DIGIT - 1
B64_DIGITS_PER_SLICE = 4
BYTES_PER_SLICE = 4 * BITS_PER_B64_DIGIT / 8

def bytes_to_base64(bytes_array)

  return "" if bytes_array.empty?
  raise ArgumentError, "bytes must be in #{BYTE_RANGE}" unless bytes_array.all? {|b| BYTE_RANGE.include?(b) }
  
  # Prepend 0s so we can convert slices of 3 bytes into 4 b64 digits
  bytes_array.unshift(0) until (bytes_array.length % BYTES_PER_SLICE).zero?

  b64_digits = bytes_array.each_slice(BYTES_PER_SLICE).flat_map do |bytes_slice|
    packed_4_bytes = "\x00" + bytes_slice.pack("C#{BYTES_PER_SLICE}")
    slice_as_uint32 = packed_4_bytes.unpack("N").first
    Array.new(B64_DIGITS_PER_SLICE) do |i|
      n_bit_shift = (B64_DIGITS_PER_SLICE - 1 - i) * BITS_PER_B64_DIGIT
      b64_digit_int = (slice_as_uint32 >> n_bit_shift) & B64_DIGIT_MASK
      B64_DIGITS[b64_digit_int]
    end
  end

  b64_string = b64_digits.drop_while {|d| d == B64_DIGITS[0] } # strip leading "zeroes"
  b64_string.empty? ? B64_DIGITS[0] : b64_string.join("")
end
