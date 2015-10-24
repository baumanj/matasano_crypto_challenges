# Byte-at-a-time ECB decryption (Simple)
# Copy your oracle function to a new function that encrypts buffers under ECB mode using a consistent but unknown key (for instance, assign a single random key, once, to a global variable).

# Now take that same function and have it append to the plaintext, BEFORE ENCRYPTING, the following string:

# Um9sbGluJyBpbiBteSA1LjAKV2l0aCBteSByYWctdG9wIGRvd24gc28gbXkg
# aGFpciBjYW4gYmxvdwpUaGUgZ2lybGllcyBvbiBzdGFuZGJ5IHdhdmluZyBq
# dXN0IHRvIHNheSBoaQpEaWQgeW91IHN0b3A/IE5vLCBJIGp1c3QgZHJvdmUg
# YnkK
# Spoiler alert.
# Do not decode this string now. Don't do it.

# Base64 decode the string before appending it. Do not base64 decode the string by hand; make your code do it. The point is that you don't know its contents.

# What you have now is a function that produces:

# AES-128-ECB(your-string || unknown-string, random-key)
# It turns out: you can decrypt "unknown-string" with repeated calls to the oracle function!

# Here's roughly how:

# Feed identical bytes of your-string to the function 1 at a time --- start with 1 byte ("A"), then "AA", then "AAA" and so on. Discover the block size of the cipher. You know it, but do this step anyway.
# Detect that the function is using ECB. You already know, but do this step anyways.
# Knowing the block size, craft an input block that is exactly 1 byte short (for instance, if the block size is 8 bytes, make "AAAAAAA"). Think about what the oracle function is going to put in that last byte position.
# Make a dictionary of every possible last byte by feeding different strings to the oracle; for instance, "AAAAAAAA", "AAAAAAAB", "AAAAAAAC", remembering the first block of each invocation.
# Match the output of the one-byte-short input to one of the entries in your dictionary. You've now discovered the first byte of unknown-string.
# Repeat for the next byte.
# Congratulations.
# This is the first challenge we've given you whose solution will break real crypto. Lots of people know that when you encrypt something in ECB mode, you can see penguins through it. Not so many of them can decrypt the contents of those ciphertexts, and now you can. If our experience is any guideline, this attack will get you code execution in security tests about once a year.

if __FILE__ == $0
  puts `rspec -f documentation #{__FILE__}`
end

require "rspec"
require "securerandom"

require "./crypto"
require "./natural_language_processing"
require "./type_conversion"

def create_ecb_encryption_oracle(unknown_string, key_bits = 128)
  key = SecureRandom.random_bytes(key_bits / 8)
  proc do |your_string|
    plaintext = "#{your_string}#{unknown_string}"
    crypt_aes_ecb(:encrypt, key_bits, plaintext, key)
  end
end

unknown_string_base64 = "Um9sbGluJyBpbiBteSA1LjAKV2l0aCBteSByYWctdG9wIGRvd24gc28gbXkgaGFpciBjYW4gYmxvdwpUaGUgZ2lybGllcyBvbiBzdGFuZGJ5IHdhdmluZyBqdXN0IHRvIHNheSBoaQpEaWQgeW91IHN0b3A/IE5vLCBJIGp1c3QgZHJvdmUgYnkK"
unknown_string = base64_to_raw(unknown_string_base64)

describe :discover_block_size do
  # AES is a variant of Rijndael which has a fixed block size of 128 bits, and a key size of 128, 192, or 256 bits.
  # —https://en.wikipedia.org/wiki/Advanced_Encryption_Standard
  block_size = 16
  key_sizes = [128, 192, 256]
  key_sizes.each do |key_bits|
    it "returns #{block_size} when called with #{key_bits}-bit oracle" do
      oracle = create_ecb_encryption_oracle(unknown_string, key_bits)
      expect(send(subject, oracle)).to eq(block_size)
    end
  end
end

describe :decrypt_ecb do
  it "returns something somewhat intelligible when given an ECB encryption created with #{unknown_string_base64}" do
    oracle = create_ecb_encryption_oracle(unknown_string)
    plaintext = send(subject, oracle)
    # puts plaintext
    expect(valid_word_pct(plaintext)).to be > 80
  end
end

def discover_block_size(oracle)
  plaintext = ""
  previous_ciphertext_size = oracle.call(plaintext).size
  loop do
    plaintext << 0.chr
    ciphertext_size = oracle.call(plaintext).size
    block_size = ciphertext_size - previous_ciphertext_size
    return block_size if block_size.nonzero?
  end
end

def decrypt_ecb(oracle)
  block_size = discover_block_size(oracle)
  ""
end