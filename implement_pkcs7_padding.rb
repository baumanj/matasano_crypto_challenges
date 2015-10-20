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

require "./crypto"

describe :pkcs7 do
  input = "YELLOW SUBMARINE"
  output = "YELLOW SUBMARINE\x04\x04\x04\x04"
  padded_size = 20
  it "returns #{output} when padding #{input} to #{padded_size}" do
    expect(send(subject, :pad, input, padded_size)).to eq(output)
    expect(send(subject, :unpad, output)).to eq(input)
  end

  block_size = 16
  it "pads and unpads up to #{block_size - 1} bytes" do
    0.upto(block_size - 1) do |pad_bytes|
      input = "X" * (block_size - pad_bytes)
      output = send(subject, :pad, input, block_size)
      expect(output.size).to eq(block_size)
      expect(send(subject, :unpad, output)).to eq(input)
    end
  end

  it "gives an error on invalid input" do
    expect { send(subject, :pad, input, rand(input.size)) }.to raise_error(ArgumentError)
    expect { send(subject, :pad, input, 0) }.to raise_error(ArgumentError)
    expect { send(subject, :pad, input, -1) }.to raise_error(ArgumentError)
  end
end
