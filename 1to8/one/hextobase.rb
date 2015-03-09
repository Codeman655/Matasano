#!/Users/chricrai/.rvm/rubies/ruby-2.0.0-p0/bin/ruby
#// ------------------------------------------------------------
#
#1. Convert hex to base64 and back.
#
#The string:
#
#  49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d
#
#  should produce:
#
#    SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t
#
#    Now use this code everywhere for the rest of the exercises. Here's asimple rule of thumb:  Always operate on raw bytes, never on encoded strings. Only use hex  and base64 for pretty-printing.
#    // ------------------------------------------------------------
#
require 'base64'
def bin_to_hex(s)
  s.each_byte.map { |b| b.to_s(16) }.join
end

def hex_to_bin(s)
  s.scan(/../).map { |x| x.hex.chr }.join
end

def base_e(s)
  return Base64.encode64(s)
end
def base_d(s)
  return Base64.decode64(s)
end

if ARGV.length != 1
  exit 0
end

puts "Binary:"
puts hex_to_bin(ARGV.first.strip)
puts "\n"
puts "Base64 encoded: "
puts base_e(hex_to_bin(ARGV.first.strip))
