# An ECB/CBC detection oracle
# Now that you have ECB and CBC working:

# Write a function to generate a random AES key; that's just 16 random bytes.

# Write a function that encrypts data under an unknown key --- that is, a function that generates a random key and encrypts under it.

# The function should look like:

# encryption_oracle(your-input)
# => [MEANINGLESS JIBBER JABBER]
# Under the hood, have the function append 5-10 bytes (count chosen randomly) before the plaintext and 5-10 bytes after the plaintext.

# Now, have the function choose to encrypt under ECB 1/2 the time, and under CBC the other half (just use random IVs each time for CBC). Use rand(2) to decide which to use.

# Detect the block cipher mode the function is using each time. You should end up with a piece of code that, pointed at a block box that might be encrypting ECB or CBC, tells you which one is happening.

if __FILE__ == $0
  puts `rspec -f documentation #{__FILE__}`
end

require "rspec"
require "securerandom"

require "./crypto"

describe :encryption_oracle do
  it "determines whether ECB or CBC is being used 100 times in 100" do
    actual_mode = nil
    100.times do
      guessed_mode = send(subject) do |plaintext|
        actual_mode, ciphertext = random_encrypt(plaintext)
        ciphertext
      end
      expect(guessed_mode).to eq(actual_mode)
    end
  end
end

def random_encrypt(plaintext)
  key = SecureRandom.random_bytes(16)
  added_bytes = "X" * (5 + rand(6))
  if rand(2).zero?
    [:ECB, encrypt_aes_128_ecb(plaintext, key)]
  else
    iv = SecureRandom.random_bytes(16)
    [:CBC, encrypt_aes_128_cbc(plaintext, iv, key)]
  end
end

def encryption_oracle
  block_size = 16
  ciphertext = yield SecureRandom.random_bytes(block_size) * 3
  n_byte_chunks(ciphertext, block_size)[1..2].uniq.size == 1 ? :ECB : :CBC
end
