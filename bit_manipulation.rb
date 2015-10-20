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

def count_set_bits(x)
  # OPTIMIZE if needed
  x.bytes.map {|i| i.to_s(2) }.join.delete("0").length
end

def hamming_distance(a, b)
  count_set_bits(xor(a, b))
end

def n_byte_chunks(buffer, n_bytes, include_tail: true)
  tail = if include_tail && (remainder = buffer.size % n_bytes).nonzero?
    buffer[-remainder, remainder]
  end
  buffer.scan(/.{#{n_bytes}}/m) + [tail].compact
end
