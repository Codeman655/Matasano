#!/Users/chricrai/.rvm/rubies/ruby-2.0.0-p0/bin/ruby
require 'base64'
load "my_lib.rb"
load "xorcipher.rb"
# // ------------------------------------------------------------
#4. Detect single-character XOR
#
#  One of the 60-character strings at:
#
#  https://gist.github.com/3132713
#
#  has been encrypted by single-character XOR. Find it. (Your code from
#  #3 should help.)
#
#// ------------------------------------------------------------

if ARGV.length != 1
  exit 0
end

def main
  #there should be 1 metric crap-ton of checking to make sure the file 
  #given is the right format/type/etc. "SHOULD" being the key word in
  #the previous statement
fp = File.open(ARGV.first,"r")
record = {}
puts "Grinding on data...\n"
fp.each { |line|
  score, data = xor_finder (line) #returns the highest score
  record[score] = [line, data]
}
high_score = record.keys.sort { |x,y| y <=> x }.first 
puts "Hex:"
puts record[high_score].first
puts "Key:Score:Decrypted Text"
puts record[high_score].last
end
main
