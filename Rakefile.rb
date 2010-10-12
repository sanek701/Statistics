
require 'yaml'
require 'preprocess'

TEXT_EDITOR = 'scite'
MAIN = 'main.tex'
RESULT = 'term_paper.pdf'
GLOBAL_DATA = 'data/global.yaml'
USER_DATA = "data/#{YAML.load_file(GLOBAL_DATA)['variant']}.yaml";

MAIN_INPUTS = File.new(MAIN).readlines.join.scan(/^\\input\{\w+\}/).map do |name|
  name.sub(/\\input\{/, "").chop + ".tex" 
end

rule '.tex' => ['.tex.erb'] do |t|
  process_erb(t.source, t.name)
end

task :default => [:termpaper]

task :help do
  puts "If you want build term paper, type: rake termpaper"
  puts "If you want change term paper info, type: rake setinfo"
  puts "If you want look at this help, type: rake help"
end

task :images do
  Dir.chdir("images_src")
  sh "rake all"
  sh "rake veryclean"
  Dir.chdir("..")
end

task :termpaper => [:clean] + MAIN_INPUTS + [:images, GLOBAL_DATA, USER_DATA] do
  3.times do
    sh "latex #{MAIN}"
  end
  sh "dvips -o main.ps main.dvi"
  sh "ps2pdf main.ps"
end

task :setinfo do
  sh "#{TEXT_EDITOR} data/global.yaml"
end

task :clean do
  rm Dir["*~"]
  rm Dir["*.log"]
  rm Dir["*.aux"]
  rm Dir["*.toc"]
  rm Dir["*.out"]
  rm Dir["*.pdf"]
  rm Dir["*.ps"]
  rm Dir["*.dvi"]
  rm Dir["*.tmp"]
  rm Dir["images/*.eps"]

  all_files = Dir["*"]
  all_files.each do |file|
    rm file if all_files.include?("#{file}.erb")
  end
end

