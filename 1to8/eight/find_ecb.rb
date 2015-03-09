#// ------------------------------------------------------------
#
#  8. Detecting ECB
#
#     At the following URL are a bunch of hex-encoded ciphertexts:
#
#     https://gist.github.com/3132928
#
#     One of them is ECB encrypted. Detect it.
#
#     Remember that the problem with ECB is that it is stateless and
#     deterministic; the same 16 byte plaintext block will always produce
#     the same 16 byte ciphertext.
#
#  // ------------------------------------------------------------

require 'openssl'
load "my_lib.rb"
BLOCKSIZE=16


def main
  #key = "YELLOW SUBMARINE" #testkey exactly 16 bytes (1 block)
  begin
  fp = File.open("gistfile1.txt",'r')
  rescue => e
    puts "Please provide the correct file: \"gistfile1.txt\""
    exit
  end
  fp.each do   |line| 
    #unpack into bytestring
    #bin_line = hex_to_int(line.strip).pack("C*")
    bin_line = line
    #bin_arr = bin_line.scan(/.{16}/)
    bin_arr = bin_line.scan(/.{32}/)
    bin_arr.map do |block|
      count=  bin_arr.count(block) 
      if count >=2
        puts "candidate: " + line
        puts "block: " + block.inspect
        puts "count: " + count.to_s
        puts "--"
      end
    end
  end
end
main
