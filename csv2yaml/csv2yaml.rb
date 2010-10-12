require "jcode"
$KCODE = "u"

DATAFILE = "data.csv"
PATH = "../data/"
NVARIANTS = 24

selection_size = [25,25,30]
table_interval = 2

#load data
data = File.open(DATAFILE).readlines.map{|line| line.split(";").map{|x| x.sub(",", ".").to_f}}

for v in 1..NVARIANTS
	f = File.open(PATH+"#{v}.yaml", "w")
	f.puts "---"
	#task 1
	position = table_interval
	f.puts "1: {data: ["
	for i in 1...selection_size[0];
		f.puts "\t#{data[position][2*(v-1)]},"
		position+=1
	end
	f.puts "\t#{data[position][2*(v-1)]}],"
	f.puts "\thiststart: 1,"
	f.puts "\thiststep: 1.5"
	f.puts "}"
	#task 2
	position = table_interval
	f.puts "2: {data: ["
	for i in 1...selection_size[1];
		f.puts "\t#{data[position][2*(v-1)+1]},"
		position+=1
	end
	f.puts "\t#{data[position][2*(v-1)+1]}],"
	f.puts "\thiststart: 0.0,"
	f.puts "\thiststep: 2.5"
	f.puts "}"
	#task 3
	position = 2*table_interval+selection_size[0]
	f.puts "3: {data: ["
	for i in 1...selection_size[1];
		f.puts "\t#{data[position][2*(v-1)]},"
		position+=1
	end
	f.puts "\t#{data[position][2*(v-1)]}]"
	f.puts "}"
	#task 4
	position = 2*table_interval+selection_size[0]
	f.puts "4: {data: ["
	for i in 1...selection_size[1];
		f.puts "\t#{data[position][2*(v-1)+1]},"
		position+=1
	end
	f.puts "\t#{data[position][2*(v-1)+1]}]"
	f.puts "}"
	#task 5
	position = 3*table_interval+selection_size[0]+selection_size[1]
	f.puts "5: {data: ["
	for i in 1...selection_size[2];
		f.puts "\t#{data[position][3*(v-1)+0].to_i},"
		position+=1
	end
	f.puts "\t#{data[position][3*(v-1)+0].to_i}],"
	f.puts "title: \"Мат. анализ\""
	f.puts "}"
	#task 6
	position = 3*table_interval+selection_size[0]+selection_size[1]
	f.puts "6: {data: ["
	for i in 1...selection_size[2];
		f.puts "\t#{data[position][3*(v-1)+1].to_i},"
		position+=1
	end
	f.puts "\t#{data[position][3*(v-1)+1].to_i}],"
	f.puts "title: \"Геометрия\""
	f.puts "}"
	#task 7
	position = 3*table_interval+selection_size[0]+selection_size[1]
	f.puts "7: {data: ["
	for i in 1...selection_size[2];
		f.puts "\t#{data[position][3*(v-1)+2].to_i},"
		position+=1
	end
	f.puts "\t#{data[position][3*(v-1)+2].to_i}],"
	f.puts "title: \"Дискр. мат.\""
	f.puts "}"
end
