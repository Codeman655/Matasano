# !/Users/chricrai/.rvm/rubies/ruby-2.0.0-p0/bin/ruby
# // ------------------------------------------------------------
# 
# 7. AES in ECB Mode
# 
# The Base64-encoded content at the following location:
# 
#     https://gist.github.com/3132853
# 
# Has been encrypted via AES-128 in ECB mode under the key
# 
#     "YELLOW SUBMARINE".
# 
# (I like "YELLOW SUBMARINE" because it's exactly 16 bytes long).
# 
# Decrypt it.
# 
# Easiest way:
# 
# Use OpenSSL::Cipher and give it AES-128-ECB as the cipher.
# 
# // ------------------------------------------------------------

require 'openssl'
require 'base64'
key = "YELLOW SUBMARINE"
fp = File.open "gistfile1.txt",'r'
data_buf = fp.map { |line|
  line.strip
}.join
cipher = OpenSSL::Cipher.new 'AES-128-ECB'
cipher.decrypt
cipher.key = key
#puts "whatever"
#out = cipher.update("whatever") #this autopads each block
#out << cipher.final
#p out
#cipher.decrypt
#cipher.key = key

#decrypted = cipher.update File.read "gistfile1.txt"
decrypted = cipher.update(Base64.decode64(data_buf))
decrypted << cipher.final #why is this a problem?

p decrypted
