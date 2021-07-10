class Customer
  attr_reader :user
  # customers.csv からユーザーデータを読み込み
  def initialize
    @lists = []
    CSV.foreach("customers.csv", headers: true) do |row|
      @lists << {id: row["id"].to_i, name: row["name"], point: row["point"].to_i, password: row["password"]}
    end
  end

# ログイン
  def sign_in
    while true
      print "ログインID を入力 > "
      id = gets.chomp.to_i
      print "パスワードを入力 > "
      password = STDIN.noecho(&:gets).chomp
      break if @user = @lists.find { |list| list[:id] == id && list[:password] == password }
      puts "\n【！】ログイン ID 、または パスワード が違います。"
    end
    p @user
    puts "\nこんにちは、#{@user[:name]}様。"
  end

  # 商品番号の入力（複数可）
  def choose_product(products)
    while true
      print "ご購入の商品番号を入力してください。 > "
      product_num = gets.split(' ').map(&:to_i)
      if product_num.any?
        break if product_num.all? { |num| num.between?(1, products.length) }
      end
      puts "【！】入力した商品番号はありません。"
    end
    product_num
  end
end
