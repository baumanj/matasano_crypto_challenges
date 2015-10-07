# Fixed XOR
# Write a function that takes two equal-length buffers and produces their XOR combination.

# If your function works properly, then when you feed it the string:

# 1c0111001f010100061a024b53535009181c
# ... after hex decoding, and when XOR'd against:

# 686974207468652062756c6c277320657965
# ... should produce:

# 746865206b696420646f6e277420706c6179

if __FILE__ == $0
  puts `rspec -f documentation #{__FILE__}`
else
  require "rspec"
end

describe :fixed_xor do
  HEX1 = "1c0111001f010100061a024b53535009181c"
  HEX2 = "686974207468652062756c6c277320657965"
  XOR  = "746865206b696420646f6e277420706c6179"

  it "returns #{XOR} when called with #{HEX1} and #{HEX2}" do
    expect(fixed_xor(HEX1, HEX2)).to eq(XOR)
  end
end

def fixed_xor(*buffers)
end
