#!/usr/bin/ruby

require 'yaml'
require 'preprocess'


# yaml-файл с описанием mp-файлов картинок
#
# содержит массив хэшей следующего вида: 
# {file: <имя_mp_файла>, image_cnt: <кол-во_изображений>, dependences: [<файл1>, <файл2>, ...]}
#   
#  Например файл <make.lst.yaml> :
#  >  ---
#  >    - {file: "sorternet", image_cnt: 23, dependences: ["sndefs.mp"]}
#  >    - {file: "funcelem",  image_cnt: 2,  dependences: ["funcelemdefs.mp"]}
#  >
IMAGE_LIST_YAML = 'make.lst.yaml'
# имя временного файла для создания иллюстаций
TMP_FILE = 'tmp'
# файл latex заголовка, в нем указаны используемые пакеты
#   Например файл <preheader.tex> :
#   >  \documentclass[12pt]{amsart}
#   >  \usepackage{anysize,amssymb,amsthm,verbatim,epsfig,graphics,longtable}
#   >  \usepackage[unicode]{hyperref}
#   >  \endinput
#   >
PREHEADER = 'preheader'
# папка куда будут складываться сгенерированные картинки
DEST_FOLDER = '../images'

  
# программы
LATEX = 'latex'
MPOST = 'mpost -tex=latex'
DVIPS = 'dvips'

task :default do 
  puts "Run: rake { all | <mpfile> }"
  puts "Available tasks: all, clean, veryclean"
end

rule( Regexp.new("^#{Regexp.escape(DEST_FOLDER)}/[\\w\\.]+\\.eps$") => 
      [lambda{ |task_name| task_name.sub("#{DEST_FOLDER}/", "") }] ) do |t|
  puts "rule #{t.name}" 
  #result_name = t.name.dup
  #result_name[result_name =~ /\.\d+/] = '_'
  sh "mv #{t.source} #{t.name}"
end

rule '.mp' => '.mp.erb' do |t|
  process_erb(t.source, t.name)
end

rule( /^[^\/]+\.eps$/ => [lambda{ |task_name| task_name.sub(/\.eps$/, "") }]) do |t|
  file = File.new("#{TMP_FILE}.tex", "w")
  file.puts(%{
    \\input{#{PREHEADER}}
    \\DeclareGraphicsRule{*}{eps}{*}{}
    \\nofiles
    \\begin{document}
    \\thispagestyle{empty}
    \\includegraphics{#{t.source}}
    \\end{document}
  })
  file.close

  sh "#{LATEX} #{TMP_FILE}"
  sh "#{DVIPS} -E -o #{t.name} #{TMP_FILE}"
  rm Dir["#{TMP_FILE}.*"]
end

task :clean do
  rm Dir["mpx*"]
  rm Dir["*~"]
  rm Dir["*.log"]
  rm Dir["*.mpx"]
  rm Dir["*.mp"]
  rm Dir["#{TMP_FILE}.*"]
end

directory DEST_FOLDER

MPTASKS = YAML.load_file(IMAGE_LIST_YAML)

# Зависимости для mpost-картинок.
# По одной для каждого числа из beginfig

MPTASKS.each do |mptask|
  for i in 1 .. mptask['image_cnt']
    file( "#{mptask['file']}.#{i}" => (mptask['dependences'] << DEST_FOLDER << "#{mptask['file']}.mp" << "#{PREHEADER}.tex")) do
      sh "#{MPOST} #{mptask['file']}.mp"
    end
  end
end

MPTASKS.each do |mptask|
  depend = (1 .. mptask['image_cnt']).map do |i| 
    "#{DEST_FOLDER}/#{mptask['file']}.#{i}.eps" 
  end
  if mptask['erb']
    depend << "#{mptask['file']}.mp.erb"
  end 
  task mptask['file'] => depend 
end


task :all => MPTASKS.map{ |mptask| mptask['file'] }

task :veryclean => :clean do
  files = []
  MPTASKS.each do |mptask| 
    (1 .. mptask['image_cnt']).each do |i| 
      files << "#{mptask['file']}.#{i}" 
    end
  end
  rm Dir[*files]
end
