require 'csv'
require 'io/console'
class Customer
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
    puts "\nこんにちは、#{@user[:name]}様。"
    @user
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

  # ポイントを使用するか確認
  def ask_point
    while @user[:point].positive?
      print "1.ポイントを使用する : 2.貯めておく > "
      @num = gets.chomp.to_i
      break if @num.between?(1, 2)
      puts "【！】入力を確認してください。"
    end
    @num
  end

  # 使用するポイントの入力
  def decise_point
    while @num == 1
      print "使用するポイントを入力 > "
      @use_point = gets.chomp.to_i
      break if @use_point.between?(1, @user[:point])
      puts "【！】入力を確認してください。"
    end
    @use_point
  end

    # ポイント残を更新
  def calculate_point
    if @num == 1
      @user[:point] -= @use_point
      datas = CSV.read("customers.csv")
      datas[@user[:id]][2] = @user[:point].to_s
      CSV.open("customers.csv","w") { |row|
        datas.each { |data| row << data }
      }
    end
  end
end

class Shop
  # products.csv から商品データを読み込み
  def initialize
    @products = []
    CSV.foreach("products.csv", headers: true) do |row|
      @products << {id: row["id"].to_i, name: row["name"], price: row["price"].to_i}
    end
  end

  # 商品を一覧表示
  def disp_products
    puts "  ＜商品一覧＞"
    @products.each do |product|
      puts "#{product[:id]}:#{product[:name]} : #{product[:price]}円"
    end
  end

  # ポイント残数を表示
  def point_inquiry(user)
    puts user[:point].positive? ? "現在利用できるポイントが#{user[:point]}ポイントあります。" : "現在利用できるポイントはありません。"
  end

  # 合計金額の計算
  def calculate_fee(chosen_product, use_point)
    cart = chosen_product.map { |num| @products[num - 1][:price] }
    total_price = cart.sum 
    total_price -= use_point if use_point
    puts "合計金額は#{total_price}円になります。 お買い上げありがとうございました!"
  end
end

customer = Customer.new
user = customer.sign_in
shop = Shop.new
products = shop.disp_products
chosen_product = customer.choose_product(products)
shop.point_inquiry(user)
customer.ask_point
use_point = customer.decise_point
customer.calculate_point
shop.calculate_fee(chosen_product, use_point)