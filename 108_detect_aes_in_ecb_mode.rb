# Detect AES in ECB mode
# In this file are a bunch of hex-encoded ciphertexts.

# One of them has been encrypted with ECB.

# Detect it.

# Remember that the problem with ECB is that it is stateless and deterministic; the same 16 byte plaintext block will always produce the same 16 byte ciphertext.

if __FILE__ == $0
  puts `rspec -f documentation #{__FILE__}`
end

require "rspec"

require "./type_conversion"
require "./crypto"

describe :find_hex_ciphertext do
  it "finds one ciphertext with duplicated blocks" do
    hex_ciphertexts = File.read("8.txt").split
    ciphertexts = hex_ciphertexts.map {|c| hex_to_raw(c) }
    ciphertext = send(subject, ciphertexts)
    hex_ciphertext = raw_to_hex(ciphertext)
    puts "Answer: line #{1 + hex_ciphertexts.index(hex_ciphertext)}: #{hex_ciphertext}"
  end
end

def find_hex_ciphertext(ciphertexts)
  candidates = ciphertexts.map do |ciphertext|
    key_size = 16
    key_sized_chunks = n_byte_chunks(ciphertext, key_size)
    Struct.new(:ciphertext, :num_dups)[ciphertext, key_sized_chunks.size - key_sized_chunks.uniq.size]
  end
  candidates.max_by(&:num_dups).ciphertext
end
