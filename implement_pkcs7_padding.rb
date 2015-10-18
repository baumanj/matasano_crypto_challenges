# Implement PKCS#7 padding
# A block cipher transforms a fixed-sized block (usually 8 or 16 bytes) of plaintext into ciphertext. But we almost never want to transform a single block; we encrypt irregularly-sized messages.

# One way we account for irregularly-sized messages is by padding, creating a plaintext that is an even multiple of the blocksize. The most popular padding scheme is called PKCS#7.

# So: pad any block to a specific block length, by appending the number of bytes of padding to the end of the block. For instance,

# "YELLOW SUBMARINE"
# ... padded to 20 bytes would be:

# "YELLOW SUBMARINE\x04\x04\x04\x04"

if __FILE__ == $0
  puts `rspec -f documentation #{__FILE__}`
end

require "rspec"

describe :pkcs7_pad do
  input = "YELLOW SUBMARINE"
  output = "YELLOW SUBMARINE\x04\x04\x04\x04"
  padded_size = 20

  it "returns #{output} when padding #{input} to #{padded_size}" do
    expect(send(subject, input, padded_size)).to eq(output)
  end
end

def pkcs7_pad(buffer, padded_size)
end
