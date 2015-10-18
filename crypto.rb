require "openssl"

require "./type_conversion"
require "./bit_manipulation"
require "./natural_language_processing"

def repeating_key_xor(buffer:, key:)
  full_copies, additional_bytes = buffer.length.divmod(key.length)
  repeated_key = key * full_copies + key[0, additional_bytes]

  xor(buffer, repeated_key)
end

def find_key(ciphertext, top_chars = TOP_ENGLISH_CHARS_BY_FREQ[:the_dictionary])
  candidates = (0...2**8).map(&:chr).map do |key|
    plaintext = repeating_key_xor(buffer: ciphertext, key: key)
    score = score_plaintext(plaintext, top_chars)
    Struct.new(:key, :plaintext, :score).new(key, plaintext, score)
  end

  candidates.sort_by(&:score).each do |c|
    puts "#{raw_to_hex(c.key)}(#{c.score})\t=> #{c.plaintext.inspect}"
  end

  candidates.max_by(&:score).key
end

def decrypt_aes_128_ecb(buffer, key)
  cipher = OpenSSL::Cipher.new('AES-128-ECB').decrypt
  cipher.key = key
  cipher.update(buffer) + cipher.final
end
