# Detect single-character XOR
# One of the 60-character strings in this file has been encrypted by single-character XOR.

# Find it.

# (Your code from #3 should help.)

if __FILE__ == $0
  puts `rspec -f documentation #{__FILE__}`
end

require "rspec"
require "securerandom"

require "./single-byte_xor_cipher"

describe :find_ciphertext do
  possible_hex_ciphertexts = Array.new(5).map { SecureRandom.hex(HEX_CIPHERTEXT.length) }
  possible_hex_ciphertexts << HEX_CIPHERTEXT
  possible_hex_ciphertexts.shuffle!

  it "finds the hex string that has been encrypted by single-character XOR" do
    expect(find_ciphertext(possible_hex_ciphertexts)).to eq(HEX_CIPHERTEXT)
  end
end

describe :downcase_ciphertext do
  it "lowers the case of encrypted text" do
    expect(decrypt(HEX_CIPHERTEXT, hex_key: KEY)).to eq(raw_to_hex(PLAINTEXT))
    expect(decrypt(HEX_CIPHERTEXT, hex_key: KEY)).to_not eq(raw_to_hex(PLAINTEXT.downcase))

    downcased_hex_ciphertext = raw_to_hex(downcase_ciphertext(hex_to_raw(HEX_CIPHERTEXT)))
    expect(decrypt(downcased_hex_ciphertext, hex_key: KEY)).to eq(raw_to_hex(PLAINTEXT.downcase))
  end

end

def raw_to_hex(raw)
  raw.unpack("H*").first
end

def downcase_ciphertext(ciphertext)
  case_bit = ("A".ord ^ "a".ord)
  ciphertext.bytes.map {|c| c | case_bit }.map(&:chr).join
end

def find_ciphertext(possible_hex_ciphertexts)
end
