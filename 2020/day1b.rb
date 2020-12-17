# def sum(a,b,c)
#   @numbers[a]+@numbers[b]+@numbers[c]
# end

numbers = File.readlines(ARGV[0]).map(&:to_i).sort
numbers.each do |n1|
  numbers.each do |n2|
    numbers.each do |n3|
      if n1+n2+n3 == 2020
        puts n1,n2,n3,n1+n2+n3,n1*n2*n3
      end
    end
  end
end
# p1,p2,p3 = 0,1,2
# while (sum(p1,p2,p3)!=2020)
#   puts "p1: #{p1}, p2: #{p2}, p3: #{p3},#{@numbers[p1]}+#{@numbers[p2]}+#{@numbers[p3]}=#{sum(p1,p2,p3)}"
#   if sum < 2020
# end
# puts "p1: #{p1}, p2: #{p2}, p3: #{p3},#{@numbers[p1]}+#{@numbers[p2]}+#{@numbers[p3]}=#{sum(p1,p2,p3)}"
# puts @numbers[p1]*@numbers[p2]*@numbers[p3]

