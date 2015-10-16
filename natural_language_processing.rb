TOP_ENGLISH_CHARS_BY_FREQ = {
  # Just an guess; I could look this up, but let's see if this suffices
  guessing: [' ', 'R', 'S', 'T', 'L', 'N', 'E', 'D', 'H', 'I', 'O', 'A'],

  # Generated from the challenge text itself minus the hex ciphertext with the following:
  # upcase.chars.sort.chunk(&:itself).map {|letter, instances| [letter, instances.length] }.sort_by(&:last).map(&:first).reverse[0, 12]
  challenge_text: [" ", "E", "O", "T", "I", "N", "A", "H", "S", "R", "C", "D"],

  # Generated from a similar command on /usr/share/dict/words, removing "\n", adding " "
  the_dictionary: [" ", "E", "I", "A", "O", "R", "N", "T", "S", "L", "C", "U"],

  a_joke: ["E", "T", "A", "O", "I", "N", " ", "S", "H", "R", "D", "L", "U"]
}

def score_plaintext(plaintext, top_chars = TOP_ENGLISH_CHARS_BY_FREQ[:the_dictionary])
  plaintext.upcase.scan(/[#{top_chars.join}]/).length
end

def valid_word_pct(plaintext)
  words = plaintext.gsub(/[^\w\s]/, "").split.map do |word|
    `grep -i "^#{word}$" /usr/share/dict/words`.empty? ? nil : word
  end
  if words.any?
    valid_words = words.compact
    puts "words: #{words}, valid_words: #{valid_words}"
    100 * valid_words.length.to_f / words.length
  else
    0
  end
end
