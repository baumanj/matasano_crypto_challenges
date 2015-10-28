# Detect single-character XOR
# One of the 60-character strings in this file has been encrypted by single-character XOR.

# Find it.

# (Your code from #3 should help.)

if __FILE__ == $0
  puts `rspec -f documentation #{__FILE__}`
end

require "rspec"
require "securerandom"

require "./103_single-byte_xor_cipher"
require "./long_running"

shared_examples "a find_hex_ciphertext function" do
  it "finds the hex string that has been encrypted by single-character XOR among random hex strings" do
    possible_hex_ciphertexts = Array.new(100).map { SecureRandom.hex(SingleByteXORCipher::HEX_CIPHERTEXT.length) }
    possible_hex_ciphertexts << SingleByteXORCipher::HEX_CIPHERTEXT
    possible_hex_ciphertexts.shuffle!
    expect(send(subject, possible_hex_ciphertexts)).to eq(SingleByteXORCipher::HEX_CIPHERTEXT)
  end

  it "finds a hex string that decrypts to mostly valid words among the example file" do
    hex_ciphertext = send(subject, File.readlines("4.txt").map(&:chomp))
    ciphertext = hex_to_raw(hex_ciphertext)
    key = find_key(ciphertext)
    plaintext = hex_to_raw(decrypt(hex_ciphertext, hex_key: raw_to_hex(key)))
    expect(valid_word_pct(plaintext)).to be > 50
  end
end

describe :find_hex_ciphertext_fast do
  it_behaves_like "a find_hex_ciphertext function"
end

describe :find_hex_ciphertext_slow do
  it_behaves_like "a find_hex_ciphertext function"
end

describe :downcase_ciphertext do
  hex_ciphertext = SingleByteXORCipher::HEX_CIPHERTEXT
  key = SingleByteXORCipher::KEY
  plaintext = SingleByteXORCipher::PLAINTEXT

  it "lowers the case of encrypted text" do
    expect(decrypt(hex_ciphertext, hex_key: key)).to eq(raw_to_hex(plaintext))
    expect(decrypt(hex_ciphertext, hex_key: key)).to_not eq(raw_to_hex(plaintext.downcase))

    downcased_hex_ciphertext = raw_to_hex(downcase_ciphertext(hex_to_raw(hex_ciphertext)))
    expect(decrypt(downcased_hex_ciphertext, hex_key: key)).to eq(raw_to_hex(plaintext.downcase))
  end

end

# Slow, but simple: Finished in 11.98 seconds (files took 0.13045 seconds to load)
def find_hex_ciphertext_slow(possible_hex_ciphertexts)
  long_running do
    ciphertexts = possible_hex_ciphertexts.map do |hex_ciphertext|
      long_running_progress
      key = find_key(hex_to_raw(hex_ciphertext))
      plaintext = hex_to_raw(decrypt(hex_ciphertext, hex_key: raw_to_hex(key)))
      Struct.new(:hex, :plaintext_score)[hex_ciphertext, score_plaintext(plaintext)]
    end

    ciphertexts.max_by(&:plaintext_score).hex
  end
end

# Fast, but more complex: Finished in 1.85 seconds (files took 0.14201 seconds to load)
def find_hex_ciphertext_fast(possible_hex_ciphertexts)
  ciphertexts = possible_hex_ciphertexts.map do |hex_ciphertext|
    ciphertext_score = score_ciphertext_histogram(hex_to_raw(hex_ciphertext))
    Struct.new(:hex, :ciphertext_score, :plaintext)[hex_ciphertext, ciphertext_score]
  end

  # Searching in ciphertext_score order, return the first fully printable string
  ciphertexts.sort_by(&:ciphertext_score).reverse_each do |ciphertext|
    key = find_key(hex_to_raw(ciphertext.hex))
    ciphertext.plaintext = hex_to_raw(decrypt(ciphertext.hex, hex_key: raw_to_hex(key)))
    return ciphertext.hex if all_printable_characters?(ciphertext.plaintext)
  end
end
