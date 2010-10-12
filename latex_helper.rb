
module LatexHelper
  def number_in_text(num)
    "#{num < 0 ? 'минус' : ''} $#{num.abs.to_s}$"
  end 

  def roundn(num, n)
    (num*(10**n)).round.to_f/(10**n)
  end
end

class Float
  alias :to_s_old :to_s
  
  def to_s
    to_s_old.gsub(".", "{,}")
  end
end
