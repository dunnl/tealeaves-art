def command?(command)
  system("which #{command} > /dev/null 2>&1")
end

if command?("tealeaves-art")
  then builder = "tealeaves-art"
  else builder = "cabal run tealeaves-art --"
end

$out_dir = "_out"
$nodes_dir = "_out/nodes"

Dir.mkdir $out_dir unless File.directory?($out_dir)
Dir.mkdir $nodes_dir unless File.directory?($nodes_dir)

commands = ["logo", "cube", "tree"]
large_sizes = ["512", "256", "128", "96"]
fdout = File.open("#{$out_dir}/output.txt", "a")
fderr = File.open("#{$out_dir}/error.txt", "a")
commands.each do |cmd|
  large_sizes.each do |size|
    Kernel.spawn("#{builder} --selection #{cmd} --output _out/#{cmd}_#{size}.png --width #{size}",
                 :out => fdout, :err => fderr)
  end
end
fdout.close
fderr.close

nodes = ["node-f", "node-d", "node-dt", "node-m", "node-dm", "node-dt", "node-dtm"]
small_sizes = ["64", "32", "16"]
fdout = File.open("#{$nodes_dir}/output.txt", "a")
fderr = File.open("#{$nodes_dir}/error.txt", "a")
nodes.each do |cmd|
  small_sizes.each do |size|
    Kernel.spawn("#{builder} --selection #{cmd} --output _out/nodes/#{cmd}_#{size}.png --width #{size}",
                 :out => fdout, :err => fderr)
  end
end
fdout.close
fderr.close
