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

HEX_CIPHERTEXT = "1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736"
# found first with brute force + visually scanning output (c.f. master 80d4fb4)
HEX_PLAINTEXT = "436f6f6b696e67204d432773206c696b65206120706f756e64206f66206261636f6e"
PLAINTEXT = "Cooking MC's like a pound of bacon"
KEY = "58"

describe :decrypt do

  it "returns the PLAINTEXT when the proper key is applied" do
    expect(decrypt(HEX_CIPHERTEXT, hex_key: KEY)).to eq(HEX_PLAINTEXT)
    expect(decrypt("00", hex_key: "00")).to eq("00")
    expect(decrypt("f00f", hex_key: "ff")).to eq("0ff0")
  end

  it "requires two args, one of them named 'key'" do
    expect { decrypt() }.to raise_error(ArgumentError)
    expect { decrypt(HEX_CIPHERTEXT) }.to raise_error(ArgumentError)
    expect { decrypt(HEX_CIPHERTEXT, hex_key: SecureRandom.hex(1)) }.to_not raise_error
  end

  it "requires key to be one hex byte" do
    expect { decrypt(HEX_CIPHERTEXT, hex_key: SecureRandom.hex(1)[0]) }.to raise_error(ArgumentError)
    long_hex_key = SecureRandom.hex(100)
    3.upto(long_hex_key.length - 1) do |num_hex_digits|
      expect { decrypt(HEX_CIPHERTEXT, hex_key: long_hex_key[0, num_hex_digits]) }.to raise_error(ArgumentError)
    end
    expect { decrypt("beef", hex_key: "cake") }.to raise_error(ArgumentError)
    expect { decrypt("dead", hex_key: "b0d") }.to raise_error(ArgumentError)
    expect { decrypt("dead", hex_key: "kk") }.to raise_error(ArgumentError)
  end

  it "requires HEX_CIPHERTEXT to be full hex bytes" do
    expect(decrypt(SecureRandom.hex(0), hex_key: SecureRandom.hex(1))).to eq("")
    random_hex = SecureRandom.hex(SecureRandom.random_number(100))
    expect { decrypt(random_hex, hex_key: SecureRandom.hex(1)) }.to_not raise_error
    expect { decrypt(random_hex[1..-1], hex_key: SecureRandom.hex(1)) }.to raise_error(ArgumentError)
  end  

end

describe :find_key do
  let(:hex_plaintext) { decrypt(HEX_CIPHERTEXT, hex_key: find_key(HEX_CIPHERTEXT)) }

  it "finds a key that decrypts the HEX_CIPHERTEXT to mostly words in the dict file" do
    words = hex_plaintext.gsub(/[^\w\s]/, "").split.map do |word|
      `grep -i "^#{word}$" /usr/share/dict/words`.empty? ? nil : word
    end
    valid_words = words.compact
    expect(valid_words.length * 2).to be > words.length
  end

  it "finds a key that decrypt the HEX_CIPHERTEXT to all printing characters" do
    expect(hex_plaintext.scan(/[^[:print:][:space:]]/)).to be_empty
  end
end

require "./fixed_xor"

def hex_to_raw(hex_bytes)
  [hex_bytes].pack("H*")
end

def decrypt(hex_HEX_CIPHERTEXT, hex_key:)
  fail ArgumentError, "key must be one full hex byte" if hex_key.length != 2

  repeated_hex_key = hex_key * (hex_HEX_CIPHERTEXT.length / hex_key.length)
  fixed_xor(hex_HEX_CIPHERTEXT, repeated_hex_key)
end

def find_key(hex_ciphertext)
  # Brute force
  hex_keys = (0...2**8).map {|k| bytes_to_hex([k]) }
  probable_hex_keys = hex_keys.select do |potential_hex_key|
    hex_plainext = decrypt(hex_ciphertext, hex_key: potential_hex_key)
    plaintext = hex_to_raw(hex_plainext)
    puts "#{potential_hex_key} => #{plaintext.inspect}" if plaintext =~ /\w/
    plaintext.scan(/\w/).length * 2 > plaintext.length
  end
  puts "#{probable_hex_keys.length}/#{hex_keys.length} Probable keys:"
  probable_hex_keys.each do |probable_hex_key|
    probable_hex_plaintext = decrypt(hex_ciphertext, hex_key: probable_hex_key)
    puts "#{probable_hex_key} => #{hex_to_raw(probable_hex_plaintext).inspect}"
  end
  probable_hex_keys.sample
end
