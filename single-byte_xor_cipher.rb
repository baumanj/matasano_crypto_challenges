# Single-byte XOR cipher
# The hex encoded string:

# 1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736
# ... has been XOR'd against a single character. Find the key, decrypt the message.

# You can do this by hand. But don't: write code to do it for you.

# How? Devise some method for "scoring" a piece of English plaintext. Character frequency is a good metric. Evaluate each output and choose the one with the best score.

# Achievement Unlocked
# You now have our permission to make "ETAOIN SHRDLU" jokes on Twitter.


if __FILE__ == $0
  puts `rspec -f documentation #{__FILE__}`
end

require "rspec"
require "securerandom"

describe :decrypt do
  CIPHERTEXT = "1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736"
  PLAINTEXT = "1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736"

  it "returns the plaintext when the proper key is applied" do
    KEY = 0x00
    expect(decrypt(CIPHERTEXT, key: KEY)).to eq(PLAINTEXT)
    expect(decrypt("00", key: "00")).to eq("00")
    expect(decrypt("f00f", key: "ff")).to eq("0ff0")
  end

  it "requires two args, one of them named 'key'" do
    expect { decrypt() }.to raise_error(ArgumentError)
    expect { decrypt(CIPHERTEXT) }.to raise_error(ArgumentError)
    expect { decrypt(CIPHERTEXT, key: SecureRandom.hex(1)) }.to_not raise_error(ArgumentError)
  end

  it "requires key to be one hex byte" do
    expect { decrypt(CIPHERTEXT, key: SecureRandom.hex(1)[0]) }.to raise_error(ArgumentError)
    long_hex_key = SecureRandom.hex(100)
    3.upto(long_hex_key.length - 1) do |num_hex_digits|
      expect { decrypt(CIPHERTEXT, key: long_hex_key[0, num_hex_digits]) }.to raise_error(ArgumentError)
    end
    expect { decrypt("beef", "cake") }.to raise_error(ArgumentError)
    expect { decrypt("dead", "b0d") }.to raise_error(ArgumentError)
  end

  it "requires ciphertext to be full hex bytes" do
    expect(decrypt(SecureRandom.hex(0), key: SecureRandom.hex(1))).to eq("")
    random_hex = SecureRandom.hex(SecureRandom.random_number(100))
    expect { decrypt(random_hex, key: SecureRandom.hex(1)) }.to_not raise_error(ArgumentError)
    expect { decrypt(random_hex[1..-1], key: SecureRandom.hex(1)) }.to raise_error(ArgumentError)
  end  

  describe :find_key do
    let(:plaintext) { decrypt(CIPHERTEXT, key: find_key(CIPHERTEXT)) }

    it "finds a key that decrypts the ciphertext to mostly words in the dict file" do
      words = plaintext.gsub(/[^\w\s]/, "").split.map do |word|
        `grep -i "^#{word}$" /usr/share/dict/words`.empty? ? nil : word
      end
      valid_words = words.compact
      expect(valid_words.length).to be >= 2 * words.length
    end

    it "finds a key that decrypt the ciphertext to all printing characters" do
      expect(plaintext.scan(/[^[:print:][:space:]]/)).to be_empty
    end
  end
end

def decrypt(ciphertext, key: nil)
end

def find_key(ciphertext)
end
