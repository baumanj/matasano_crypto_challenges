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

# Generated from /usr/share/dict/words
# Values are permille (i.e, 10 x percent)
ENGLISH_CHARS_HISTOGRAM = {
  "Z"=>0,
  "Q"=>1,   #
  "J"=>1,   #
  "X"=>2,   ##
  "'"=>3,   ###
  "V"=>8,   ########
  ","=>9,   #########
  "."=>9,   #########
  "K"=>10,  ##########
  "B"=>11,  ###########
  "F"=>16,  ################
  "W"=>16,  ################
  "Y"=>18,  ##################
  "P"=>19,  ###################
  "D"=>22,  ######################
  "G"=>23,  #######################
  "U"=>24,  ########################
  "M"=>24,  ########################
  "C"=>26,  ##########################
  "L"=>33,  #################################
  "H"=>36,  ####################################
  "R"=>47,  ###############################################
  "S"=>49,  #################################################
  "N"=>54,  ######################################################
  "I"=>58,  ##########################################################
  "O"=>62,  ##############################################################
  "A"=>66,  ##################################################################
  "T"=>77,  #############################################################################
  "E"=>95,  ###############################################################################################
  " "=>179, ###################################################################################################################################################################################
}

ENGLISH_BIGRAMS_HISTOGRAM = {
  "SK"=>1,  #
  "NV"=>1,  #
  "DD"=>1,  #
  "DN"=>1,  #
  "TC"=>1,  #
  "OK"=>1,  #
  "LP"=>1,  #
  "RV"=>1,  #
  "AW"=>1,  #
  "YD"=>1,  #
  "GG"=>1,  #
  "RK"=>1,  #
  "NL"=>1,  #
  "YO"=>1,  #
  "NR"=>1,  #
  "NY"=>1,  #
  "HL"=>1,  #
  "DY"=>1,  #
  "NK"=>1,  #
  "AF"=>1,  #
  "OX"=>1,  #
  "LD"=>1,  #
  "ZO"=>1,  #
  "UG"=>1,  #
  "XI"=>1,  #
  "KA"=>1,  #
  "YA"=>1,  #
  "EW"=>1,  #
  "PY"=>1,  #
  "NP"=>1,  #
  "OF"=>1,  #
  "AY"=>1,  #
  "CC"=>1,  #
  "VO"=>1,  #
  "SN"=>1,  #
  "YR"=>1,  #
  "RH"=>1,  #
  "YT"=>1,  #
  "HT"=>1,  #
  "FR"=>1,  #
  "ZA"=>1,  #
  "GY"=>1,  #
  "YC"=>1,  #
  "YN"=>1,  #
  "GH"=>1,  #
  "FF"=>1,  #
  "OE"=>1,  #
  "IU"=>1,  #
  "YM"=>1,  #
  "HU"=>1,  #
  "RL"=>1,  #
  "GN"=>1,  #
  "IK"=>1,  #
  "RB"=>1,  #
  "EB"=>1,  #
  "EV"=>1,  #
  "UE"=>1,  #
  "RG"=>1,  #
  "MM"=>1,  #
  "PP"=>1,  #
  "AK"=>1,  #
  "AV"=>1,  #
  "DU"=>1,  #
  "DL"=>1,  #
  "WE"=>1,  #
  "SY"=>1,  #
  "NF"=>1,  #
  "FA"=>1,  #
  "NU"=>1,  #
  "WO"=>1,  #
  "TL"=>1,  #
  "PS"=>1,  #
  "SL"=>1,  #
  "EF"=>1,  #
  "WI"=>1,  #
  "LT"=>1,  #
  "MY"=>1,  #
  "YS"=>1,  #
  "UD"=>1,  #
  "NN"=>1,  #
  "RP"=>1,  #
  "OA"=>1,  #
  "GU"=>1,  #
  "FL"=>1,  #
  "PU"=>1,  #
  "MU"=>1,  #
  "KI"=>1,  #
  "EG"=>1,  #
  "OW"=>1,  #
  "UI"=>1,  #
  "FU"=>1,  #
  "MB"=>1,  #
  "EI"=>1,  #
  "YP"=>1,  #
  "UA"=>1,  #
  "RN"=>1,  #
  "CY"=>1,  #
  "BU"=>1,  #
  "UC"=>1,  #
  "YL"=>1,  #
  "WA"=>2,  ##
  "UP"=>2,  ##
  "EU"=>2,  ##
  "HR"=>2,  ##
  "IB"=>2,  ##
  "VA"=>2,  ##
  "FE"=>2,  ##
  "OB"=>2,  ##
  "TT"=>2,  ##
  "PT"=>2,  ##
  "GO"=>2,  ##
  "CL"=>2,  ##
  "EX"=>2,  ##
  "UB"=>2,  ##
  "DR"=>2,  ##
  "AU"=>2,  ##
  "ZE"=>2,  ##
  "RR"=>2,  ##
  "RS"=>2,  ##
  "RD"=>2,  ##
  "CK"=>2,  ##
  "FO"=>2,  ##
  "QU"=>2,  ##
  "OV"=>2,  ##
  "RC"=>2,  ##
  "AI"=>2,  ##
  "RU"=>2,  ##
  "EE"=>2,  ##
  "IE"=>2,  ##
  "BR"=>2,  ##
  "FI"=>2,  ##
  "GL"=>2,  ##
  "OI"=>2,  ##
  "BO"=>2,  ##
  "EO"=>2,  ##
  "VI"=>2,  ##
  "IF"=>2,  ##
  "MP"=>2,  ##
  "LU"=>2,  ##
  "IG"=>2,  ##
  "IR"=>2,  ##
  "IZ"=>2,  ##
  "OO"=>2,  ##
  "TU"=>2,  ##
  "GR"=>2,  ##
  "AE"=>2,  ##
  "RM"=>2,  ##
  "PL"=>2,  ##
  "KE"=>2,  ##
  "GA"=>2,  ##
  "IP"=>3,  ###
  "CU"=>3,  ###
  "IM"=>3,  ###
  "IV"=>3,  ###
  "BA"=>3,  ###
  "GI"=>3,  ###
  "UT"=>3,  ###
  "BE"=>3,  ###
  "CR"=>3,  ###
  "AG"=>3,  ###
  "TY"=>3,  ###
  "BI"=>3,  ###
  "OD"=>3,  ###
  "DO"=>3,  ###
  "SM"=>3,  ###
  "RT"=>3,  ###
  "SP"=>3,  ###
  "EP"=>3,  ###
  "SA"=>3,  ###
  "AD"=>3,  ###
  "UM"=>3,  ###
  "SO"=>3,  ###
  "RY"=>3,  ###
  "DA"=>3,  ###
  "NS"=>3,  ###
  "HY"=>3,  ###
  "SC"=>3,  ###
  "SU"=>3,  ###
  "PI"=>3,  ###
  "CT"=>3,  ###
  "AP"=>4,  ####
  "CI"=>4,  ####
  "SH"=>4,  ####
  "AM"=>4,  ####
  "OG"=>4,  ####
  "GE"=>4,  ####
  "OC"=>4,  ####
  "EM"=>4,  ####
  "EC"=>4,  ####
  "PA"=>4,  ####
  "NC"=>4,  ####
  "MO"=>4,  ####
  "BL"=>4,  ####
  "PO"=>4,  ####
  "OT"=>4,  ####
  "UR"=>4,  ####
  "AB"=>4,  ####
  "HA"=>5,  #####
  "ND"=>5,  #####
  "PR"=>5,  #####
  "UL"=>5,  #####
  "AS"=>5,  #####
  "EA"=>5,  #####
  "IL"=>5,  #####
  "HO"=>5,  #####
  "HI"=>5,  #####
  "CE"=>5,  #####
  "VE"=>5,  #####
  "ID"=>5,  #####
  "OS"=>5,  #####
  "PE"=>6,  ######
  "OP"=>6,  ######
  "MI"=>6,  ######
  "LL"=>6,  ######
  "SE"=>6,  ######
  "ET"=>6,  ######
  "SI"=>6,  ######
  "TH"=>6,  ######
  "NO"=>6,  ######
  "ME"=>6,  ######
  "DI"=>6,  ######
  "OM"=>6,  ######
  "HE"=>6,  ######
  "OL"=>6,  ######
  "AC"=>6,  ######
  "NA"=>6,  ######
  "EL"=>6,  ######
  "OU"=>6,  ######
  "LO"=>6,  ######
  "NG"=>6,  ######
  "PH"=>7,  #######
  "CH"=>7,  #######
  "MA"=>7,  #######
  "DE"=>7,  #######
  "LY"=>7,  #######
  "TR"=>7,  #######
  "SS"=>7,  #######
  "TA"=>7,  #######
  "US"=>7,  #######
  "ED"=>7,  #######
  "CA"=>8,  ########
  "NI"=>8,  ########
  "IA"=>8,  ########
  "TO"=>8,  ########
  "IO"=>8,  ########
  "CO"=>8,  ########
  "LA"=>8,  ########
  "IT"=>8,  ########
  "UN"=>10, ##########
  "OR"=>10, ##########
  "NT"=>10, ##########
  "ES"=>10, ##########
  "LI"=>10, ##########
  "AR"=>11, ###########
  "NE"=>11, ###########
  "ST"=>11, ###########
  "RO"=>11, ###########
  "RI"=>12, ############
  "LE"=>12, ############
  "RA"=>12, ############
  "RE"=>12, ############
  "IS"=>12, ############
  "EN"=>12, ############
  "IC"=>13, #############
  "AT"=>13, #############
  "AL"=>14, ##############
  "AN"=>14, ##############
  "TE"=>15, ###############
  "ON"=>15, ###############
  "TI"=>16, ################
  "IN"=>17, #################
  "ER"=>21, #####################
}

def array_to_freq_hash(array)
  Hash[array.sort.chunk(&:itself).map {|e, es| [e, es.length] }]
end

def score_plaintext_histogram(plaintext)
  plaintext_chars = plaintext.upcase.chars
  plaintext_histogram = array_to_freq_hash(plaintext_chars)

  keys = ENGLISH_CHARS_HISTOGRAM.keys + (plaintext_histogram.keys - ENGLISH_CHARS_HISTOGRAM.keys)
  value_pairs = keys.map do |char|
    plaintext_instances = plaintext_histogram.fetch(char, 0)
    expected_instances = (plaintext_chars.length * (ENGLISH_CHARS_HISTOGRAM.fetch(char, 0) / 1000.0)).round
    [char, [plaintext_instances, expected_instances]]
  end
  char_score = value_pairs.map do |char, p|
    # plusses = '+' * p.min
    # spaces = ' ' * [(p.last - p.first), 0].max
    # minuses = '-' * [(p.first - p.last), 0].max
    # puts "#{char.inspect} #{p.join(', ')} #{2 * p.min - p.max}\t#{plusses}#{spaces}\##{minuses}" 
    2 * p.min - p.max
  end
  char_score.reduce(&:+)
end

# def score_plaintext_histogram(plaintext)
# # def score_plaintext_bigrams(plaintext)
#   words = plaintext.gsub(/[[:punct:]\d]/, "").upcase.split
#   words.map! {|w| w.length == 1 ? "#{w} " : w } # Don't lose "I" and "a"
#   plaintext_bigrams = words.flat_map {|w| w.chars.each_cons(2).map(&:join) }
#   plaintext_bigrams_histogram = array_to_freq_hash(plaintext_bigrams)

#   value_pairs = plaintext_bigrams_histogram.map do |bigram, plaintext_instances|
#     expected_instances = plaintext.length * (ENGLISH_BIGRAMS_HISTOGRAM.fetch(bigram, 0) / 1000.0)
#     [bigram, [plaintext_instances, expected_instances]]
#   end
#   char_score = value_pairs.map do |bigram, p|
#     # plusses = '+' * p.min
#     # spaces = ' ' * [(p.last - p.first), 0].max
#     # minuses = '-' * [(p.first - p.last), 0].max
#     # puts "#{bigram.inspect} #{p.join(', ')} #{2 * p.min - p.max}\t#{plusses}#{spaces}\##{minuses}" 
#     2 * p.min - p.max
#   end
#   char_score.reduce(&:+)
# end

def score_plaintext(plaintext, top_chars = TOP_ENGLISH_CHARS_BY_FREQ[:the_dictionary])
  plaintext.upcase.scan(/[#{top_chars.join}]/).length
end

def all_printable_characters?(buffer)
  buffer[/[^[:graph:][:space:]]/].nil?
end

def valid_word_pct(plaintext)
  @dict ||= File.read("/usr/share/dict/words").downcase.split
  words = plaintext.gsub(/[^\w\s]/, "").downcase.split.map do |word|
    @dict.include?(word) && word
  end
  if words.any?
    valid_words = words.compact
    # puts "words: #{words}, valid_words: #{valid_words}"
    100 * valid_words.length.to_f / words.length
  else
    0
  end
end

def sanitize(s)
  s.chars.map {|c| c.inspect.length == 3 ? c : "?" }.join.inspect
end
