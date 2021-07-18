#! ruby -EUTF-8
# -*- mode:ruby; coding:utf-8 -*-
#
# 2021/07/18, Sun.
#
# Ref.
# 1) https://en.wikipedia.org/wiki/Logarithm#Feynman's_algorithm

include Math

#--------------------------------------------------------------------------------
# A tutorial code for understaning the Feynman's algorithm
#--------------------------------------------------------------------------------
def log2_feynman_u8_to_u3p16(x)
                                                              puts " --------"
                                                              puts " x = %3d" % x
  #--------------------------------------------------------------------------------
  # Compute interger part, searching possible right-shift quantities by binary method.
  ans_int = 0
  xw      = x
  if (t = (xw>>4))>0
    xw = t; ans_int += 4
  end
  if (t = (xw>>2))>0
    xw = t; ans_int += 2
  end
  if (t = (xw>>1))>0
    xw = t; ans_int += 1
  end
                                                              puts " ans_int = %2d, %05Xh" % [ans_int, ans_int<<16]
  #--------------------------------------------------------------------------------
  # Compute log2(x) fragment part for 1.0< = x < 2.0, x being 1.b1_b2_b3_b4_..._b7
  # by Feynman's algorithm
  ans_frag = 0
  x_scaled = (x << (7 - ans_int))   # u1.7 <-- u8
  pw = 128    # 1.0 in u1.7
                                                              puts " x_scaled = %4d" % x_scaled
  1.upto(7){|k|
    t = pw + (pw>>k)
                                                              s1 = " stage=%d, pw=%4d, t=%4d" % [k, pw, t]
    if t < x_scaled
      pw = t
      ans_frag += (log2(1.0+1.0/(2**k)) * 65536).round(0) # Of course, the RHS should be a constant integer to be read from a table.
    end
                                                              puts "%s, new pw=%4d, ans_frag=%5d, %05Xh" % [s1, pw, ans_frag, ans_frag]
  }
  ans = (ans_int << 16) + ans_frag
                                                              puts " ans = %8d, %05Xh" % [ans, ans]
  return ans
end

#--------------------------------------------------------------------------------
# main
#--------------------------------------------------------------------------------
puts "log2(x)_feynman: u8 --> u3p16"

1.upto(255){|x|
  y = log2_feynman_u8_to_u3p16(x)
  y_dbl = y/65536.0

  y_mf      = log2(x)           # Math function
  y_mf_int  = y_mf * 65536.0
  puts "M:x=%4d, ans=(%8d, %05Xh, %12.8f), y_mf=(%12.8f, %10.1f)" % [x, y, y, y_dbl, y_mf, y_mf_int]
}
