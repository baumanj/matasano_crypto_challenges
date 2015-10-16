require "./type_conversion"

def xor(*buffers)
  fail ArgumentError, "buffers must be equal length" if buffers.map(&:length).uniq.length != 1

  byte_arrays = buffers.map(&:bytes)
  xored_bytes = byte_arrays.transpose.map {|byte_column| byte_column.reduce(&:^) }
  bytes_to_raw(xored_bytes)
end

def downcase_ciphertext(ciphertext)
  case_bit = ("A".ord ^ "a".ord)
  downcased_bytes = ciphertext.bytes.map {|c| c | case_bit }
  bytes_to_raw(downcased_bytes)
end
