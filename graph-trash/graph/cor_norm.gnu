reset
set key off
set zeroaxis ls -1
set xtics axis
set xrange [0:9]
set xtics 0, 1
set terminal postscript eps
set output "img/cor_norm.eps"
plot "data/cor_norm.dat" with linespoints lc -1 pt 7
