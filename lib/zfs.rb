class ZFS

  def self.list(type = :filesystem)

    fs = []

    IO.popen("zfs list -H -t #{type}") do |f|
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

  def self.snap(zf, name = nil)

    name = name ? name : DateTime.now.to_s
    IO.popen("zfs snapshot #{zf}@#{name}") do |f|
    end

  end

  def self.clone(snap, zf)

    #Think on this for a bit need pool name? 

    IO.popen("zfs clone #{snap} #{zf}") do |f|
    end

  end

  def self.prop(zf = "")

    x = Hash.new
    IO.popen("zfs get -H all #{zf}") do |f|
      while l = f.gets do
        c = l.chomp.split
        x[c[0]] ||= Hash.new
        x[c[0]][c[1]] = c[2]
      end
    end
    x

  end

  def self.destroy(zf)
    IO.popen("zfs destroy -R #{zf}") do |f|
    end
  end
  
end

