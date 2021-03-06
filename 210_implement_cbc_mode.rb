# Implement CBC mode
# CBC mode is a block cipher mode that allows us to encrypt irregularly-sized messages, despite the fact that a block cipher natively only transforms individual blocks.

# In CBC mode, each ciphertext block is added to the next plaintext block before the next call to the cipher core.

# The first plaintext block, which has no associated previous ciphertext block, is added to a "fake 0th ciphertext block" called the initialization vector, or IV.

# Implement CBC mode by hand by taking the ECB function you wrote earlier, making it encrypt instead of decrypt (verify this by decrypting whatever you encrypt to test), and using your XOR function from the previous exercise to combine them.

# The file here is intelligible (somewhat) when CBC decrypted against "YELLOW SUBMARINE" with an IV of all ASCII 0 (\x00\x00\x00 &c)

# Don't cheat.
# Do not use OpenSSL's CBC code to do CBC mode, even to verify your results. What's the point of even doing this stuff if you aren't going to learn from it?

if __FILE__ == $0
  puts `rspec -f documentation #{__FILE__}`
end

require "rspec"
require "securerandom"

require "./type_conversion"
require "./crypto"
require "./natural_language_processing"

describe :crypt_aes_128_ecb do
  it "returns the original buffer when composing decrypt and encrypt" do
    buffer = SecureRandom.random_bytes
    key = SecureRandom.random_bytes
    expect(send(subject, :decrypt, send(subject, :encrypt, buffer, key), key)).to eq(buffer)
  end
end

block_size = 16

describe :decrypt_aes_128_cbc do
  file = "10.txt"
  key = "YELLOW SUBMARINE"
  iv = "\x00" * block_size

  it "returns something somewhat intelligible when decrypting #{file} against #{key.inspect} with an IV of #{iv.inspect}" do
    ciphertext = base64_to_raw(File.readlines(file).join)
    plaintext = send(subject, ciphertext, iv, key)
    # puts plaintext
    expect(valid_word_pct(plaintext)).to be > 80
  end
end

describe :crypt_aes_128_cbc do
  key = SecureRandom.random_bytes
  iv = SecureRandom.random_bytes(block_size)

  it "returns the original buffer when composing decrypt and encrypt" do
    num_blocks = rand(100)
    buffer = SecureRandom.random_bytes(block_size * num_blocks)
    expect(send(subject, :decrypt, send(subject, :encrypt, buffer, iv, key), iv, key)).to eq(buffer)
  end

  it "handles partial blocks" do
    partial_block_size = 1 + rand(block_size - 1)
    buffer = SecureRandom.random_bytes((1 + rand(10)) * block_size + partial_block_size)
    expect(send(subject, :decrypt, send(subject, :encrypt, buffer, iv, key), iv, key)).to eq(buffer)
  end
end
