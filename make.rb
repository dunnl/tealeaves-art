def command?(command)
  system("which #{command} > /dev/null 2>&1")
end

if command?("tealeaves-art")
then
  $builder = "tealeaves-art"
else
  $builder = "cabal run tealeaves-art --"
end

def go (dir, selections, sizes)
  Dir.mkdir dir unless File.directory? dir
  fdout = File.open("#{dir}/output.txt", "a")
  fderr = File.open("#{dir}/error.txt", "a")
  selections.each do |sel|
    sizes.each do |size|
      command = "#{$builder} --selection #{sel} --output #{dir}/#{sel}_#{size}.png --width #{size}"
      Kernel.spawn(command, :out => fdout, :err => fderr)
    end
  end
  fdout.close
  fderr.close
end

def mkImages
  selections = ["logo", "cube", "tree"]
  sizes = ["512", "256", "128", "96"]
  go("_out", selections, sizes)
end

def mkNodes
  selections = ["node-f", "node-d", "node-dt", "node-m", "node-dm", "node-dt", "node-dtm"]
  sizes = ["64", "32", "16"]
  go("_out/nodes", selections, sizes)
end

mkImages
mkNodes

