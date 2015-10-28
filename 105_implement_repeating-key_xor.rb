# Implement repeating-key XOR
# Here is the opening stanza of an important work of the English language:

# Burning 'em, if you ain't quick and nimble
# I go crazy when I hear a cymbal
# Encrypt it, under the key "ICE", using repeating-key XOR.

# In repeating-key XOR, you'll sequentially apply each byte of the key; the first byte of plaintext will be XOR'd against I, the next C, the next E, then I again for the 4th byte, and so on.

# It should come out to:

# 0b3637272a2b2e63622c2e69692a23693a2a3c6324202d623d63343c2a26226324272765272
# a282b2f20430a652e2c652a3124333a653e2b2027630c692b20283165286326302e27282f
# Encrypt a bunch of stuff using your repeating-key XOR function. Encrypt your mail. Encrypt your password file. Your .sig file. Get a feel for it. I promise, we aren't wasting your time with this.

if __FILE__ == $0
  puts `rspec -f documentation #{__FILE__}`
end

require "rspec"

require "./bit_manipulation"
require "./crypto"

module RepeatingKeyXOR
  PLAINTEXT ||= "Burning 'em, if you ain't quick and nimble\nI go crazy when I hear a cymbal"
  KEY ||= "ICE"
  HEX_CIPHERTEXT ||= "0b3637272a2b2e63622c2e69692a23693a2a3c6324202d623d63343c2a26226324272765272a282b2f20430a652e2c652a3124333a653e2b2027630c692b20283165286326302e27282f"
end  

describe :repeating_key_xor do

  it "requires plaintext" do
    expect { send(subject) }.to raise_error(ArgumentError)
    expect { send(subject, key: RepeatingKeyXOR::KEY) }.to raise_error(ArgumentError)
    expect(send(subject, buffer: "", key: RepeatingKeyXOR::KEY)).to eq("")
  end

  it "requires a nonzero-length key" do
    expect { send(subject) }.to raise_error(ArgumentError)
    expect { send(subject, buffer: RepeatingKeyXOR::PLAINTEXT) }.to raise_error(ArgumentError)
    expect { send(subject, buffer: RepeatingKeyXOR::PLAINTEXT, key: "") }.to raise_error(ZeroDivisionError)
  end

  it "returns #{RepeatingKeyXOR::HEX_CIPHERTEXT} when the key #{RepeatingKeyXOR::KEY} is applied to #{RepeatingKeyXOR::PLAINTEXT.inspect}" do
    expect(raw_to_hex(send(subject, buffer: RepeatingKeyXOR::PLAINTEXT, key: RepeatingKeyXOR::KEY))).to eq(RepeatingKeyXOR::HEX_CIPHERTEXT)
  end
end
