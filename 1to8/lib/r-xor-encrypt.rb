#!/Users/chricrai/.rvm/rubies/ruby-2.0.0-p0/bin/ruby
load "my_lib.rb"

#// ------------------------------------------------------------
# 
# 5. Repeating-key XOR Cipher
# 
# Write the code to encrypt the string:
# 
#   Burning 'em, if you ain't quick and nimble
#   I go crazy when I hear a cymbal
# 
# Under the key "ICE", using repeating-key XOR. It should come out to:
# 
#   0b3637272a2b2e63622c2e69692a23693a2a3c6324202d623d63343c2a26226324272765272a282b2f20430a652e2c652a3124333a653e2b2027630c692b20283165286326302e27282f
# 
# Encrypt a bunch of stuff using your repeating-key XOR function. Get a
# feel for it.
# 
# // ------------------------------------------------------------

if ARGV.length != 2
  puts "Useage: ./r-xor-encrypt.rb <key> <string>"
  exit 0
end

$key = ARGV.first
$data = ARGV.last

def encrypt (key_a, plaintext)
  count=0
  goal=[]
  plaintext.each { |x|
    goal.push(x^key_a[count % key_a.length])
    count += 1
  }
  puts goal
  return goal
end

#---main
#Easy peasy
# Take key => into binary
# xor binary into each "block" of the main text. 
# "Blocks" are defined by the size of the key

def main  
  puts $key
  puts $data
  ciphertext = encrypt $key.unpack("C*"), $data.unpack("C*")
  puts bin_to_hex(ciphertext.pack("C*"))
end

main
