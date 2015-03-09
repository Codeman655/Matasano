require 'Base64'
#load "xorcipher.rb" #I should include this file in mylib or separate the:

def bin_to_hex(s)
  s.each_byte.map { |b| b.to_s(16) }.join
end

def hex_to_bin(s)
  s.scan(/../).map { |x| x.hex.chr }.join
end

def hex_to_int(s)
  s.scan(/../).map { |x| x.hex }
end

def hex_to_sbin(s)
  s.scan(/../).map { |x| x.hex.to_s(2) }.join
end

def hex_to_dec(s)
  s.scan(/../).map { |x| x.hex }.join
end

def base_e(s)
  return Base64.encode64(s)
end

def base_d(s)
  return Base64.decode64(s)
end
