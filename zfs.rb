class ZFS

  def self.list
    fs = []
    IO.popen("zfs list -H") do |f|
      i = 0
      while l = f.gets do 
        c = l.chomp.split
        x = {}
        x[:name] = c[0]
        x[:used] = c[1]
        x[:avail] = c[2]
        x[:refer] = c[3]
        x[:mount] = c[4]
        fs[i] = x
        i += 1
      end
    end
    fs
  end
  
end

