# Single-byte XOR cipher
# The hex encoded string:

# 1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736
# ... has been XOR'd against a single character. Find the key, decrypt the message.

# You can do this by hand. But don't: write code to do it for you.

# How? Devise some method for "scoring" a piece of English HEX_PLAINTEXT. Character frequency is a good metric. Evaluate each output and choose the one with the best score.

# Achievement Unlocked
# You now have our permission to make "ETAOIN SHRDLU" jokes on Twitter.


if __FILE__ == $0
  puts `rspec -f documentation #{__FILE__}`
end

require "rspec"
require "securerandom"

require "./type_conversion"
require "./bit_manipulation"
require "./natural_language_processing"

module SingleByteXORCipher
  HEX_CIPHERTEXT = "1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736"
  # found first with brute force + visually scanning output (c.f. master 80d4fb4)
  HEX_PLAINTEXT = "436f6f6b696e67204d432773206c696b65206120706f756e64206f66206261636f6e"
  PLAINTEXT = "Cooking MC's like a pound of bacon"
  KEY = "58"
end

describe :decrypt do
  it "returns the plaintext when the proper key is applied" do
    expect(decrypt(SingleByteXORCipher::HEX_CIPHERTEXT, hex_key: SingleByteXORCipher::KEY)).to eq(SingleByteXORCipher::HEX_PLAINTEXT)
    expect(decrypt("00", hex_key: "00")).to eq("00")
    expect(decrypt("f00f", hex_key: "ff")).to eq("0ff0")
  end

  it "requires two args, one of them named 'key'" do
    expect { decrypt() }.to raise_error(ArgumentError)
    expect { decrypt(SingleByteXORCipher::HEX_CIPHERTEXT) }.to raise_error(ArgumentError)
    expect { decrypt(SingleByteXORCipher::HEX_CIPHERTEXT, hex_key: SecureRandom.hex(1)) }.to_not raise_error
  end

  it "requires key to be one hex byte" do
    expect { decrypt(SingleByteXORCipher::HEX_CIPHERTEXT, hex_key: SecureRandom.hex(1)[0]) }.to raise_error(ArgumentError)
    long_hex_key = SecureRandom.hex(100)
    3.upto(long_hex_key.length - 1) do |num_hex_digits|
      expect { decrypt(SingleByteXORCipher::HEX_CIPHERTEXT, hex_key: long_hex_key[0, num_hex_digits]) }.to raise_error(ArgumentError)
    end
    expect { decrypt("beef", hex_key: "cake") }.to raise_error(ArgumentError)
    expect { decrypt("dead", hex_key: "b0d") }.to raise_error(ArgumentError)
    expect { decrypt("dead", hex_key: "kk") }.to raise_error(ArgumentError)
  end

  it "requires the hex ciphertext to be full hex bytes" do
    expect(decrypt(SecureRandom.hex(0), hex_key: SecureRandom.hex(1))).to eq("")
    random_hex = SecureRandom.hex(SecureRandom.random_number(100))
    expect { decrypt(random_hex, hex_key: SecureRandom.hex(1)) }.to_not raise_error
    expect { decrypt(random_hex[1..-1], hex_key: SecureRandom.hex(1)) }.to raise_error(ArgumentError)
  end  

end

describe :find_key do
  TOP_ENGLISH_CHARS_BY_FREQ.each do |strategy, top_chars|
    context "when using top characters determined from #{strategy}" do
      let(:plaintext) do
        hex_to_raw(decrypt(SingleByteXORCipher::HEX_CIPHERTEXT, hex_key: find_key(SingleByteXORCipher::HEX_CIPHERTEXT, TOP_ENGLISH_CHARS_BY_FREQ[:the_dictionary])))
      end

      it "finds a key that decrypts #{SingleByteXORCipher::HEX_CIPHERTEXT} to mostly words in the dict file" do
        expect(valid_word_pct(plaintext)).to be > 50
      end

      it "finds a key that decrypts #{SingleByteXORCipher::HEX_CIPHERTEXT} to all printing characters" do
        expect(plaintext.scan(/[^[:print:][:space:]]/)).to be_empty
      end
    end
  end
end

def decrypt(hex_ciphertext, hex_key:)
  fail ArgumentError, "key must be one full hex byte" if hex_key.length != 2

  key = hex_to_raw(hex_key)
  ciphertext = hex_to_raw(hex_ciphertext)

  repeated_key = key * (ciphertext.length / key.length)
  raw_to_hex(xor(ciphertext, repeated_key))
end

Candidate = Struct.new(:hex_key, :plaintext, :score)
def find_key(hex_ciphertext, top_chars = TOP_ENGLISH_CHARS_BY_FREQ[:the_dictionary])
  candidates = (0...2**8).map do |key|
    hex_key = bytes_to_hex([key])
    hex_plainext = decrypt(hex_ciphertext, hex_key: hex_key)
    plaintext = hex_to_raw(hex_plainext)
    score = score_plaintext(plaintext, top_chars)
    Candidate.new(hex_key, plaintext, score)
  end

  ranked_candidates = candidates.sort_by(&:score)

  # ranked_candidates.each do |c|
  #   puts "#{c.hex_key}(#{c.score})\t=> #{c.plaintext.inspect}"
  # end

  ranked_candidates.last.hex_key
end
