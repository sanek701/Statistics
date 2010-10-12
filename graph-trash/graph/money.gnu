reset
set key off
set xrange [0:10]
set xtics 0, 1
set terminal postscript eps
set output "img/money.eps"
plot "data/money.dat" with linespoints lc -1 pt 7,      35.9 lc -1
