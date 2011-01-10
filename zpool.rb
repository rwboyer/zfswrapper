class ZP

  def self.list
    zp = []
    IO.popen("zpool list -H") do |f| 
      i = 0
      while l = f.gets do
        c = l.chomp.split
        x = {}
        x[:pool] = c[0]
        x[:size] = c[1]
        x[:used] = c[2]
        x[:avail] = c[3]
        x[:cap] = c[4]
        x[:health] = c[5]
        zp[i] = x
        i += 1
      end
    end
    zp
  end

end

