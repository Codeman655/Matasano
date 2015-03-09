#!/Users/chricrai/.rvm/rubies/ruby-2.0.0-p0/bin/ruby
load "my_lib.rb"
load "xorcipher.rb"
DEBUG=false

#This code takes the best 3 results and displays each result to the screen

# // ------------------------------------------------------------
# 
# 6. Break repeating-key XOR
# 
# The buffer at the following location:
# 
#  https://gist.github.com/3132752
# 
# is base64-encoded repeating-key XOR. Break it.
# 
# Here's how:
# 
# a. Let KEYSIZE be the guessed length of the key; try values from 2 to
# (say) 40.
# 
# b. Write a function to compute the edit distance/Hamming distance
# between two strings. The Hamming distance is just the number of
# differing bits. The distance between:
# 
#   this is a test
# 
# and:
# 
#   wokka wokka!!!
# 
# is 37.
# 
# c. For each KEYSIZE, take the FIRST KEYSIZE worth of bytes, and the
# SECOND KEYSIZE worth of bytes, and find the edit distance between
# 
# d. The KEYSIZE with the smallest normalized edit distance is probably
# the key. You could proceed perhaps with the smallest 2-3 KEYSIZE
# values. Or take 4 KEYSIZE blocks instead of 2 and average the
# distances.
# 
# e. Now that you probably know the KEYSIZE: break the ciphertext into
# blocks of KEYSIZE length.
# 
# f. Now transpose the blocks: make a block that is the first byte of
# every block, and a block that is the second byte of every block, and
# so on.
# 
# g. Solve each block as if it was single-character XOR. You already
# have code to do this.
# 
# e. For each block, the single-byte XOR key that produces the best
# looking histogram is the repeating-key XOR key byte for that
# block. Put them together and you have the key.
# 
# // ------------------------------------------------------------

if ARGV.length != 1
  puts "Useage: ./b-xor-encrypt.rb <filename>"
  exit 0
end


def hammer(data_array)
  ret = {}
  #archive= {}
  (2 .. 40).each { |size|  #should be 40
    samplesize = 10
    count = 0
    tmp_store=[]
    #for each sample
    (0 .. samplesize-1).each { |s| 
      start = size*2*s
      dat1 = data_array.slice(start,size)
      dat2 = data_array.slice(start+size,size)
      if dat1.length != dat2.length
        break
      end
      #count the number of bits set after an xor
      (0 .. size-1).each { |i| 
        val = dat1[i] ^ dat2[i]
        while val != 0
          if val&1 == 1
            count +=1
          end
          val = val >> 1
        end
      }
      #push the normalized score into the buffer
      tmp_store.push(count/dat1.length.to_f*8)
    }
    #divide sum of samples by the individual length
    score = tmp_store.inject{ |sum,n| sum + n } / tmp_store.length
    #p tmp_store
    #puts "score: #{score} size: #{size}"

    #store the count and divide by samplesize not the size in general
    if ret.has_key? (score)
      ret[score] += [size]
    else
      ret[score] = [size]
    end
  }

  #I do this alot. Often, when using hash tables, I put the floating
  #point value as the 'key.' It easily allows me to sort, but I need
  #to be mindful of this habit. It's easy to confuse the two.
  top3 = ret.sort { |x,y| x <=> y }.slice(0,3)

  if DEBUG == true 
    ret.each_pair{ |x,y| 
      p "#{x} : #{y}" 
    }
    puts "-"*80
    top3.map{ |x|
      puts "key: #{ret[x]} : score #{x}"
    }
    puts "-"*80
  end
  return top3#, ret[top]
end

def getdata(filename)
  IO.readlines(filename).map {|x| x.strip }.join
end

def breakdown(keysize, data)
  trans = Array.new(keysize){Array.new}
  puts "Keysize: #{ keysize }"
  (0..data.length-1).each { |i| 
    trans[i%keysize].push(data[i])
    #p "trans[#{i%keysize}] = #{data[i]}"
  }
  return trans
end

def solve(data)
  data.map{|x|
    score,key,result_str = xor_finder_a(x)
    if DEBUG == true
      puts 
      puts result_str
      puts "-"*20
      puts "Key found: #{key}"
    end
    key
  }
end

#copied over because my lib files are janked
#Old code. I now know what maps are in Ruby
def encrypt (key_a, plaintext)
  count=0
  goal=[]
  plaintext.each { |x|
    goal.push(x^key_a[count % key_a.length])
    count += 1
  }
  return goal
end

def main
  data = getdata ARGV.first
  data_a = base_d(data).unpack("C*")
  guess_dist = hammer(data_a) #Determine's the keysize with the smallest hamming distance
  keyring = guess_dist.map { |x|
    x[1].first
  }
  if DEBUG == true
    p guess_dist
  end
  keyring.each { |keysize|
    #puts "breaking down by keysize"
    #Breaks the plaintext into sequential arrays
    broken_a = breakdown(keysize, data_a)
    score, key, result_str = xor_finder_a(broken_a[0]) 
    fin_result = solve(broken_a)
    puts "Suspected key:"
    puts "#{fin_result.pack("C*")}"
    fin = encrypt(fin_result, data_a)
    p fin.pack("C*")
    puts "-"*30

    #check if the array has the same key.
    #If true => decrypt data block using the found key
    #p fin_result encrypt
  }
end

main
