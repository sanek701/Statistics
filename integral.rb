def integrate(left, right, steps, &func)
  dx = (right - left).to_f/steps
  x, fx, sum = left, func.call(left), 0.0
  steps.times do
    x += dx 
    sum += dx/6*(fx + 4*func.call(x-0.5*dx) + (fx = func.call(x)))
  end

  return sum
end

def qq(y)
  sq_y = y*y

  pow = y

  sum = 0 

  fact = 1

  for i in 2..100
    pow *= sq_y
    fact *= i
    sum += (i%2==0 ? -1 : 1)*pow/fact/(2*i-1)
  end

  return sum*0.5+y
end

def fi(x)
  return 0.5*Math.erf(x/Math.sqrt(2))
  return 1/Math.sqrt(2*Math::PI)*integrate(0, x, 1024) { |t| Math.exp(-t*t*0.5) }
end

def invfi(y, steps = nil)
  unless steps
    steps = 1024 
    [0.12, 0.2, 0.32, 0.45, 0.47, 0.49].each do |val|
      steps <<= 1 if y.abs > val
    end
  end

  h = y.to_f/steps

  xn, tn = 0.0, 0.0
  sq2pi = Math.sqrt(2*Math::PI)
  steps.times do
    fn = sq2pi*Math.exp(xn*xn*0.5)
    tn = xn + h*fn
    fn2 = sq2pi*Math.exp(tn*tn*0.5)
    xn += 0.5*h*(fn + fn2)
  end

  return xn
end


y = 0.0
while y > -0.5
  x = invfi(y)
  puts "#{x} #{y} #{y-fi(x)}"
  y -= 0.01
end
