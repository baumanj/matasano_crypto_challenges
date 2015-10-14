# Detect single-character XOR
# One of the 60-character strings in this file has been encrypted by single-character XOR.

# Find it.

# (Your code from #3 should help.)

if __FILE__ == $0
  puts `rspec -f documentation #{__FILE__}`
end

require "rspec"
require "securerandom"

describe :find_ciphertext do
  HEX_CIPHERTEXT = "1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736"
  possible_ciphertexts = Array.new(99).map { SecureRandom.hex(HEX_CIPHERTEXT.length) }
  possible_ciphertexts << HEX_CIPHERTEXT
  possible_ciphertexts.shuffle!

  it "finds the hex string that has been encrypted by single-character XOR" do
    expect(find_ciphertext(possible_ciphertexts)).to eq(HEX_CIPHERTEXT)
  end
end

def find_ciphertext(possible_ciphertexts)
end
