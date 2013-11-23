@@max = ARGV[0] || 100
@@max = @@max.to_i

@@input = 0
@@output = 0
@@others = []

def commas n
  n.to_s.reverse.gsub(/...(?=.)/,'\&,').reverse
end

class Counter

  def initialize
    @count = 0
    @fanout = 0
    @subsequent = {}
  end
  
  def value
    @count
  end
  
  def subsequent seg
    unless @subsequent.has_key? seg
      @subsequent[seg] = Counter.new 
      @fanout += 1
    end
    return @subsequent[seg]
  end
  
  def count! segments
    @count += 1 if segments.length == 0
    return unless segments.length > 0
    seg = segments.shift
    if @fanout >= @@max
      subsequent("(OTHER)").count! []
    else
      subsequent(seg).count! segments
    end
  end

  def report keys
    unless @count < 1 then
      line = "#{keys.join(' / ')} -- #{@count}"
      # puts line
      @@others << line if keys.last == "(OTHER)"
      @@output += 1
    end
    @subsequent.sort_by{|k,v| [-v.value, k]}.each do |key, count|
      keys.push key
      count.report keys
      keys.pop
    end
  end
  
end

@root = Counter.new
STDIN.readlines.each do |line|
  @@input += 1
  seq = line.chomp.split(/[ \/\t?&]/)
  # seq.shift
  @root.count! seq
end
@root.report ['']
STDERR.puts "
If segments clamped to #{@@max} names:
#{commas @@input} input => #{commas @@output} output (#{'%.02f' % (100.0*(@@input-@@output)/@@input)}% clamped)
#{@@others.join("\n")}
"

