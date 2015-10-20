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

  # candidates.sort_by(&:score).each do |c|
  #   puts "#{raw_to_hex(c.key)}(#{c.score})\t=> #{c.plaintext.inspect}"
  # end

  candidates.max_by(&:score).key
end

def decrypt_aes_128_ecb(buffer, key)
  crypt_aes_128_ecb(:decrypt, buffer, key)
end

def crypt_aes_128_ecb(encrypt_or_decrypt, buffer, key)
  cipher = aes_128_ecb(encrypt_or_decrypt, key)
  cipher.update(buffer) + cipher.final
end

def aes_128_ecb(encrypt_or_decrypt, key)
  cipher = OpenSSL::Cipher.new('AES-128-ECB').send(encrypt_or_decrypt)
  cipher.key = key
  cipher
end

def crypt_aes_128_cbc(encrypt_or_decrypt, *args)
  send("#{encrypt_or_decrypt}_aes_128_cbc", *args)
end

def encrypt_aes_128_cbc(plaintext, iv, key)
  cipher = aes_128_ecb(:encrypt, key)
  cipher.padding = 0
  block_size = 16

  plain_blocks = plaintext.scan(/.{#{block_size}}/m)
  ciphertext = plain_blocks.reduce(iv) do |ciphertext, block|
    prev_cipherblock = ciphertext[-block_size..-1]
    ciphertext + cipher.update(xor(prev_cipherblock, block))
  end
  ciphertext[block_size..-1] # omit IV
  # Need to add padding
end

def decrypt_aes_128_cbc(ciphertext, iv, key)
  cipher = aes_128_ecb(:decrypt, key)
  cipher.padding = 0
  block_size = 16

  cipher_blocks = [iv] + ciphertext.scan(/.{#{block_size}}/m)
  plain_blocks = cipher_blocks.each_cons(2).map do |prev_cipherblock, cipherblock|
    prev_cipherblock_xor_plainblock = cipher.update(cipherblock)
    xor(prev_cipherblock, prev_cipherblock_xor_plainblock)
  end
  plain_blocks.join
  # Need to trim padding
end
