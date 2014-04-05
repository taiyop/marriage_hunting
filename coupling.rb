class User
  attr_accessor :likes_rank, :name
  def initialize(name)
    @name = name
    set_gender
  end

  def likes(array)
    @likes_rank = array
  end

  def likes_value user
    @likes_rank.each_with_index do |like_rank, index|
      return index+1 if like_rank.match(user.name)
    end
    9
  end

  def woman?
    @is_woman
  end

  private
  def set_gender
    unless @name.match(/[a-z]/).nil?
      @is_woman = true
    else
      @is_woman = false
    end
  end
end

class Couple
  attr_accessor :value, :man, :woman
  def initialize(man ,woman)
    @man = man
    @woman = woman
    set_rank
  end

  def result
    @man.name + "-" +  @woman.name + ":" + @value.to_s
  end

  private
  def set_rank
    @value = @man.likes_value(@woman) + @woman.likes_value(@man)
  end
end

mens = []
womens = []
#file 読み込みからデータ作成
f = open("like_datas2.txt")
f.each_with_index do |line, index|
  array = line.split(':')
  user = User.new(array[0])
  user.likes(array[1].strip.chomp.split(","))
  user.woman? ? womens << user : mens << user
end

# 組み合わせ作成
couples = []
mens.product(womens).each do |_couple|
  couples << Couple.new(_couple[0], _couple[1])
end
# ソート
couples = couples.sort{|a, b| a.value <=> b.value}

users = []
# 出力と、出力した組の名前を出力済みデータに保存
couples.each do |couple|
  unless users.include?(couple.man.name) || users.include?(couple.woman.name)
    p couple.result
    users << couple.man.name
    users << couple.woman.name
  end
end
