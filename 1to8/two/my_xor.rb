#!/Users/chricrai/.rvm/rubies/ruby-2.0.0-p0/bin/ruby
load "my_lib.rb"
#
#// ------------------------------------------------------------
#
#2. Fixed XOR
#
#Write a function that takes two equal-length buffers and produces
#their XOR sum.
#
#The string:
#
# 1c0111001f010100061a024b53535009181c
#
# ... after hex decoding, when xor'd against:
#
#  686974207468652062756c6c277320657965
#
#  ... should produce:
#
#   746865206b696420646f6e277420706c6179
#
#   // ------------------------------------------------------------
#puts "Given 2 hex values of equal length. Return the base64 encoded string"


if ARGV.length != 2
  exit 0
end
val1 = hex_to_bin(ARGV[0].strip)
val2 = hex_to_bin(ARGV[1].strip)

#checking lengths of arguments
if val1.length != val2.length
  exit 0
end

#unpack to integer somehow
array1 = val1.unpack("C*") #Packs the values in the bit string as 1-byte unsigned integers
p array1
array2 = val2.unpack("C*") 
p array2
out_array = []

#xor the integers
(0..array1.length-1).each { |i| 
  out_array.push(array1[i] ^ array2[i])
}
p out_array
result_string = out_array.pack("C*") #Unpacking values as 1-byte chars (original encoding)
p result_string

