#!/Users/chricrai/.rvm/rubies/ruby-2.0.0-p0/bin/ruby
require 'base64'
# // ------------------------------------------------------------
# 
# 3. Single-character XOR Cipher
# 
# The hex encoded string:
# 
#       1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736
# 
# ... has been XOR'd against a single character. Find the key, decrypt
# the message.
# 
# Write code to do this for you. How? Devise some method for "scoring" a
# piece of English plaintext. (Character frequency is a good metric.)
# Evaluate each output and choose the one with the best score.
# 
# Tune your algorithm until this works.
# 
# // ------------------------------------------------------------

$alphabet = "A" .. "Z"
$englishLetterFreq = {' ' => 14.00, 'E'=> 12.70, 'T'=> 9.06, 'A'=> 8.17, 'O'=> 7.51, 'I'=> 6.97, 'N'=> 6.75, 'S'=> 6.33, 'H'=> 6.09, 'R'=> 5.99, 'D'=> 4.25, 'L'=> 4.03, 'C'=> 2.78, 'U'=> 2.76, 'M'=> 2.41, 'W'=> 2.36, 'F'=> 2.23, 'G'=> 2.02, 'Y'=> 1.97, 'P'=> 1.93, 'B'=> 1.29, 'V'=> 0.98, 'K'=> 0.77, 'J'=> 0.15, 'X'=> 0.15, 'Q'=> 0.10, 'Z'=> 0.07}

#def countLetters ( input )
#  alphabetCount = {'A'=> 0, 'B'=> 0, 'C'=> 0, 'D'=> 0, 'E'=> 0, 'F'=> 0, 'G'=> 0, 'H'=> 0, 'I'=> 0, 'J'=> 0, 'K'=> 0, 'L'=> 0, 'M'=> 0, 'N'=> 0, 'O'=> 0, 'P'=> 0, 'Q'=> 0, 'R'=> 0, 'S'=> 0, 'T'=> 0, 'U'=> 0, 'V'=> 0, 'W'=> 0, 'X'=> 0, 'Y'=> 0, 'Z'=> 0 }
#  input.each { |letter| 
#    puts "not yet"
#    #TODO
#    #should return error if not in hash
#    #character in hash  += 1
#  }
#end

#Straight from RosettaCode, slightly modified 
def letter_frequency(str)
  #puts "length: #{str.length}"
  str.each_char.lazy.grep(/[[ :alpha:]]/).map(&:upcase).inject({}) do |freq_map, char|
    freq_map[char] ||= 0 
    freq_map[char] += 1
    freq_map
  end
end

def letter_percentage(freq_map, size)
  out={}
  freq_map.each_pair{ |key,val|
  #  puts val
    val = (val.to_f / size).to_f
  #  puts "val: #{val}"
    out[key] = val
  }
  return out
end

def score (plaintext)
  per_map = letter_percentage(letter_frequency(plaintext), plaintext.length)
  t_score = 0.0
  $englishLetterFreq.each_pair { |key, val|
    if per_map[key] != nil 
  #    p "letter: " + key.to_s
  #    p "mine: " + per_map[key].to_s
  #    p "theirs: " + (val/100).to_s
  #    p "product:" +  (per_map[key] * (val/100)).to_s
      t_score += per_map[key] * (val/100)
    end
  }
  return t_score
end

def xor_finder (ciphertext)
  b_cipher = hex_to_int(ciphertext)
  #p hex_to_bin(ciphertext)
  scores = {} 
  record = {}
  (0..255).each { |letter|  #This fucking line right here! 
    key = letter#.unpack("C*").first
    out = Array.new
    b_cipher.each{ |b| 
      out.push( key ^ b )
    }
    out_str = out.pack("C*")
    record[letter] = out_str
    total = score(out_str)
    scores[total] = letter

    #puts letter + " : " + total.to_s + " : " + out_str
  }
  #analyize out
  #puts "-"*20
  #puts "Winner"
  win_k = scores.keys.sort { |x,y| y <=> x }.first
  win_v = scores[win_k]
  return win_k, "#{win_v}:#{win_k}:#{record[win_v].inspect}"
end


def xor_finder_a(data_array)
  #p hex_to_bin(ciphertext)
  scores = {} 
  record = {}
  (0..255).each { |letter|  
    key = letter#.unpack("C*").first
    out = Array.new
    data_array.each{ |b| 
      out.push( key ^ b )
    }
    out_str = out.pack("C*")
    record[letter] = out_str
    total = score(out_str)
    scores[total] = letter

    #puts letter.to_s + " : " + total.to_s + " : " + out_str.inspect
  }
  #analyize out
  #puts "-"*20
  #puts "Winner"
  #top10 = scores.keys.sort { |x,y| y <=> x }[0,9]
  #top10.each do |x|
    #puts x
    #puts scores[x]
    #puts record[scores[x]].inspect
    #puts "-"*20
  #end
  win_k = scores.keys.sort { |x,y| y <=> x }.first
  win_v = scores[win_k]
  return win_k, win_v, "#{win_v}:#{win_k}:#{record[win_v].inspect}"
end
