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

BLOCK_SIZE ||= 16

def pkcs7(pad_or_unpad, *args)
  send("pkcs7_#{pad_or_unpad}", *args)
end

def pkcs7_pad(buffer, padded_size)
  fail ArgumentError, "padded_size must not be less than buffer size" if buffer.size > padded_size

  n_pad_bytes = padded_size - buffer.size
  buffer + n_pad_bytes.chr * n_pad_bytes
end

def pkcs7_unpad(buffer)
  if (n_pad_bytes = buffer[-1].ord) < BLOCK_SIZE
    buffer[0...-n_pad_bytes]
  else
    buffer
  end
end

def aes(encrypt_or_decrypt, key_bits, mode, key)
  cipher = OpenSSL::Cipher::AES.new(key_bits, mode).send(encrypt_or_decrypt)
  cipher.key = key
  cipher
end

def decrypt_aes_128_ecb(buffer, key)
  crypt_aes_ecb(:decrypt, 128, buffer, key)
end

def encrypt_aes_128_ecb(buffer, key)
  crypt_aes_ecb(:encrypt, 128, buffer, key)
end

def crypt_aes_128_ecb(encrypt_or_decrypt, buffer, key)
  crypt_aes_ecb(encrypt_or_decrypt, 128, buffer, key)
end

def crypt_aes_ecb(encrypt_or_decrypt, key_bits, buffer, key)
  cipher = aes(encrypt_or_decrypt, key_bits, :ECB, key)
  cipher.update(buffer) + cipher.final
end

def crypt_aes_128_cbc(encrypt_or_decrypt, *args)
  send("#{encrypt_or_decrypt}_aes_128_cbc", *args)
end

def encrypt_aes_128_cbc(plaintext, iv, key)
  cipher = aes(:encrypt, 128, :ECB, key)
  cipher.padding = 0

  plain_blocks = n_byte_chunks(plaintext, BLOCK_SIZE)
  if plain_blocks.last.size != BLOCK_SIZE
    plain_blocks.push(pkcs7_pad(plain_blocks.pop, BLOCK_SIZE))
  end
  ciphertext = plain_blocks.reduce(iv) do |ciphertext, block|
    prev_cipherblock = ciphertext[-BLOCK_SIZE..-1]
    ciphertext + cipher.update(xor(prev_cipherblock, block))
  end
  ciphertext[BLOCK_SIZE..-1] # omit IV
end

def decrypt_aes_128_cbc(ciphertext, iv, key)
  cipher = aes(:decrypt, 128, :ECB, key)
  cipher.padding = 0

  cipher_blocks = [iv] + n_byte_chunks(ciphertext, BLOCK_SIZE)
  plain_blocks = cipher_blocks.each_cons(2).map do |prev_cipherblock, cipherblock|
    prev_cipherblock_xor_plainblock = cipher.update(cipherblock)
    xor(prev_cipherblock, prev_cipherblock_xor_plainblock)
  end
  pkcs7_unpad(plain_blocks.join)
end
