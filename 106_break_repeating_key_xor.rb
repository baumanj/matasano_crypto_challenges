# Break repeating-key XOR
# It is officially on, now.
# This challenge isn't conceptually hard, but it involves actual error-prone coding. The other challenges in this set are there to bring you up to speed. This one is there to qualify you. If you can do this one, you're probably just fine up to Set 6.

# There's a file here. It's been base64'd after being encrypted with repeating-key XOR.

# Decrypt it.

# Here's how:

# Let KEYSIZE be the guessed length of the key; try values from 2 to (say) 40.
# Write a function to compute the edit distance/Hamming distance between two strings. The Hamming distance is just the number of differing bits. The distance between:
# this is a test
# and
# wokka wokka!!!
# is 37. Make sure your code agrees before you proceed.
# For each KEYSIZE, take the first KEYSIZE worth of bytes, and the second KEYSIZE worth of bytes, and find the edit distance between them. Normalize this result by dividing by KEYSIZE.
# The KEYSIZE with the smallest normalized edit distance is probably the key. You could proceed perhaps with the smallest 2-3 KEYSIZE values. Or take 4 KEYSIZE blocks instead of 2 and average the distances.
# Now that you probably know the KEYSIZE: break the ciphertext into blocks of KEYSIZE length.
# Now transpose the blocks: make a block that is the first byte of every block, and a block that is the second byte of every block, and so on.
# Solve each block as if it was single-character XOR. You already have code to do this.
# For each block, the single-byte XOR key that produces the best looking histogram is the repeating-key XOR key byte for that block. Put them together and you have the key.
# This code is going to turn out to be surprisingly useful later on. Breaking repeating-key XOR ("Vigenere") statistically is obviously an academic exercise, a "Crypto 101" thing. But more people "know how" to break it than can actually break it, and a similar technique breaks something much more important.

# No, that's not a mistake.
# We get more tech support questions for this challenge than any of the other ones. We promise, there aren't any blatant errors in this text. In particular: the "wokka wokka!!!" edit distance really is 37.

if __FILE__ == $0
  puts `rspec -f documentation #{__FILE__}`
end

require "rspec"

require "./105_implement_repeating-key_xor"
require "./bit_manipulation"
require "./natural_language_processing"
require "./long_running"

describe :hamming_distance do
  TEST_INPUTS = ["this is a test", "wokka wokka!!!"]
  TEST_OUTPUT = 37

  it "returns #{TEST_OUTPUT} for #{TEST_INPUTS.map(&:inspect).join(' and ')}" do
    expect(send(subject, *TEST_INPUTS)).to eq(TEST_OUTPUT)
  end
end

describe :break_repeating_key_xor do
  it "returns #{RepeatingKeyXOR::PLAINTEXT} for #{RepeatingKeyXOR::HEX_CIPHERTEXT}" do
    ciphertext = hex_to_raw(RepeatingKeyXOR::HEX_CIPHERTEXT)
    expect(send(subject, ciphertext)).to eq(RepeatingKeyXOR::PLAINTEXT)
  end

  it "finds returns mostly valid words for the example file" do
    b64_ciphertext = File.readlines("6.txt").map(&:chomp).join
    ciphertext = base64_to_raw(b64_ciphertext)
    plaintext = long_running { send(subject, ciphertext) }
    expect(valid_word_pct(plaintext)).to be > 50
  end
end

def transpose_for_key_size(ciphertext, key_size)
  remainder = ciphertext.size % key_size
  padding = (key_size - remainder) % key_size
  bytes = ciphertext.bytes + Array.new(padding)
  bytes.each_slice(key_size).to_a.transpose.map(&:compact)
end

def break_repeating_key_xor(ciphertext)
  min_key_size = 2
  max_key_size = [40, ciphertext.length / 2].min
  n_key_sizes_to_try = 10

  potential_key_types = (min_key_size..max_key_size).map do |key_size|
    key_sized_chunks = n_byte_chunks(ciphertext, key_size, include_tail: false)
    distances = key_sized_chunks.each_cons(2).map {|c1, c2| hamming_distance(c1, c2) }
    normalized_distances = distances.map {|d| d.to_f / key_size}
    average_normalized_distance = normalized_distances.reduce(&:+) / normalized_distances.size.to_f
    Struct.new(:size, :normalized_edit_distance, :key, :plaintext, :score)[key_size, average_normalized_distance]
  end

  potential_key_types.sort_by(&:normalized_edit_distance).first(n_key_sizes_to_try).each do |key_type|
    single_byte_ciphertext_blocks = transpose_for_key_size(ciphertext, key_type.size)
    single_byte_keys = single_byte_ciphertext_blocks.map {|bytes| find_key(bytes_to_raw(bytes)) }
    long_running_progress
    key_type.key = single_byte_keys.join
    key_type.plaintext = repeating_key_xor(buffer: ciphertext, key: key_type.key)
  end

  potential_key_types.each do |key_type|
    key_type.score = key_type.plaintext.nil? ? 0 : score_plaintext_histogram(key_type.plaintext)
  end

  potential_key_types.max_by {|k| k.score }.plaintext
end
