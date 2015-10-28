# AES in ECB mode
# The Base64-encoded content in this file has been encrypted via AES-128 in ECB mode under the key

# "YELLOW SUBMARINE".
# (case-sensitive, without the quotes; exactly 16 characters; I like "YELLOW SUBMARINE" because it's exactly 16 bytes long, and now you do too).

# Decrypt it. You know the key, after all.

# Easiest way: use OpenSSL::Cipher and give it AES-128-ECB as the cipher.

# Do this with code.
# You can obviously decrypt this using the OpenSSL command-line tool, but we're having you get ECB working in code for a reason. You'll need it a lot later on, and not just for attacking ECB.

if __FILE__ == $0
  puts `rspec -f documentation #{__FILE__}`
end

require "rspec"

require "./type_conversion"
require "./crypto"

describe :decrypt_aes_128_ecb do
  file = "7.txt"
  key = "YELLOW SUBMARINE"
  base64 = File.read("7.txt").tr("\n", "")
  buffer = base64_to_raw(base64)

  it "decrypts #{file} with the key #{key}" do
    cli_decryption = `openssl aes-128-ecb -in 7.txt -d -a -K #{raw_to_hex(key)}`
    expect(send(subject, buffer, key)).to eq(cli_decryption)
  end

  it "fails if the key is wrong" do
    i = rand(key.size)
    key[i] = key[i].succ
    expect { send(subject, buffer, key) }.to raise_error(OpenSSL::Cipher::CipherError)
  end
end
