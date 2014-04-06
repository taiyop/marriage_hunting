class User
  attr_accessor :likes_rank, :name
  @@bad_value = 99
  def initialize(name)
    @name = name
  end

  def self.bad_value
    @@bad_value
  end

  def likes(array)
    @likes_rank = array
  end

  def likes_value user
    @likes_rank.each_with_index do |like_rank, index|
      return index+1 if like_rank.match(user.name)
    end
    @@bad_value
  end

  def woman?
    @name =~ /[a-z]/
  end
end

class Couple
  attr_accessor :man, :woman
  def initialize(man ,woman)
    @man = man
    @woman = woman
  end

  def value
    @man.likes_value(@woman) + @woman.likes_value(@man)
  end

  def result
    "#{@man.name}-#{@woman.name}:#{@value.to_s}"
  end
end

men = []
women = []
#file 読み込みからデータ作成
f = open("like_datas.txt")
f.each do |line|
  array = line.chomp.split(':')
  user = User.new(array[0])
  user.likes(array[1].strip.split(","))
  user.woman? ? women << user : men << user
end

# 組み合わせ作成
couples = []
men.product(women).each do |_couple|
  couples << Couple.new(_couple[0], _couple[1])
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
