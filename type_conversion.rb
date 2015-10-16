def bytes_to_raw(bytes)
  bytes.map(&:chr).join
end

def bytes_to_hex(bytes)
  bytes.map(&:chr).join.unpack("H*").first
end

def hex_to_bytes(hex)
  fail ArgumentError, "hex buffer must be full bytes" if hex.length.odd?
  hex.scan(/../).map {|hex_byte| Integer(hex_byte, 16) }
end

def raw_to_hex(buffer)
  buffer.unpack("H*").first
end

def hex_to_raw(hex)
  hex_to_bytes(hex).pack("C*")
end
