reset
set key off
set zeroaxis ls -1
set xtics axis
set xrange [0:9]
set xtics 0, 1
set format y "%.0f"
set terminal postscript eps
set output "img/cor2.eps"
plot "data/cor2.dat" with linespoints lc -1 pt 7
