class User
  attr_accessor :name
  @@bad_value = 99
  def initialize(name)
    @name = name
  end

  def self.bad_value
    @@bad_value
  end

  def loves(users)
    @love_user_names = users
  end

  def love_point user
    point = @love_user_names.index(user.name)
    point.nil? ? @@bad_value : point + 1
  end

  def woman?
    @name =~ /[a-z]/
  end
end

class Couple
  attr_accessor :man, :woman
  def initialize(man ,woman)
    @man, @woman = man, woman
  end

  def value
    @man.love_point(@woman) + @woman.love_point(@man)
  end

  def result
    "#{@man.name}-#{@woman.name}:#{self.value.to_s}"
  end
end

men = []
women = []

love_rank_data = <<"EOS"
A:c,b,a
B:a,b,d
C:a,c,b
D:d,a,c
a:A,C,D
b:D,A,B
c:B,A,C
d:D,C,A
EOS

men = []
women = []
love_rank_data.each_line do |line|
  love_rank = line.split(':')
  user = User.new(love_rank[0])
  user.loves(love_rank[1].chomp.split(','))
  user.woman? ? women << user : men << user
end

# 組み合わせ作成
couples = []
men.product(women).each do |couple_array|
  couples << Couple.new(couple_array[0], couple_array[1])
end
# ソート
couples = couples.sort{|a, b| a.value <=> b.value}

users = []
# 出力と、出力した組の名前を出力済みデータに保存
couples.each do |couple|
  unless users.include?(couple.man.name) || users.include?(couple.woman.name)
    if couple.value <= User.bad_value
      p couple.result
      users << couple.man.name
      users << couple.woman.name
    end
  end
end
