require 'calc'
require 'sample'

module Statistic
  
  class Distribution
    attr_reader :sample

    def initialize(sample)
      @sample = sample
    end

    def paper_points
      points = []
      
      data = @sample.data.sort
      
      data.each_with_index do |val, i|
        unless data[i+1] == val
          points << [val, paper_transform(i.to_f/data.size)]
        end
      end

      return points
    end
    
    def paper_transform(y)
      raise NotImplementedError, "Not implemented method <paper_transform> called for Distribution abstract class"
    end
    
    def paper_inv_transform(x)
      raise NotImplementedError, "Not implemented method <paper_inv_transform> called for Distributiona bstract class"
    end
    
    def parameters(line = linear_approx)
      raise NotImplementedError, "Not implemented method <parameters> called for Distribution abstract class"
    end
    
    def linear_approx
      points = paper_points

      points.pop
      points.shift

      return Statistic::Calc::minimal_square_method(points)
    end
    
    def approx_diff
      line = linear_approx
      
      points = paper_points
      points.pop
      points.shift
      
      return points.inject(0) do |sum, point|
        sum + (paper_inv_transform(line[0]*point[0] + line[1]) - 
                paper_inv_transform(point[1]))**2
      end
    end 
  end
  
  class Uniform < Distribution 
    def paper_transform(y)
      return y
    end
    
    def paper_inv_transform(x)
      return x
    end
    
    def parameters(line = linear_approx)
      {:sigma => 0.5/(line[0]*Math.sqrt(3)), :m => (1 - 2*line[1]).to_f/(2*line[0])}
    end
  end 
  
  class Normal < Distribution
    def paper_transform(y) 
      return 3.20 if y > 0.999 
      return -3.20 if y < 0.001 
      return Statistic::Calc::inv_laplace_function(y-0.5) 
    end 
    
    def paper_inv_transform(x)
      return Statistic::Calc::laplace_function(x) + 0.5
    end
    
    def parameters(line = linear_approx)
      {:sigma => 1.0/line[0], :m => -line[1].to_f/line[0]}
    end
  end
  
  class Exponential < Distribution
    def parameters(line = linear_approx)
      {:lambda => line[0]}
    end
    
    def paper_transform(y)
      y = 0.99 if y > 0.99
      return -Math.log(1.0 - y)
    end
    
    def paper_inv_transform(x)
      return 1.0 - Math.exp(-x)
    end
    
    def linear_approx(fixed_zero_flag = true)
      points = paper_points
    
      points.pop
      points.shift

      if fixed_zero_flag || @sample.exponential_distribution?
        return Statistic::Calc::exponential_linnear_approximation(points)
      end

      return Statistic::Calc::minimal_square_method(points)
    end
    
    def approx_diff
      line = linear_approx(true)
      
      points = paper_points
      points.pop
      points.shift
      
      return points.inject(0) do |sum, point|
        sum + (paper_inv_transform(line[0]*point[0] + line[1]) - 
                paper_inv_transform(point[1]))**2
      end
    end
  end
end