require 'csv'
class Customer
  # customers.csv からユーザーデータを読み込み
  def initialize
    @lists = []
    CSV.foreach("customers.csv", headers: true) do |row|
      @lists << {id: row["id"].to_i, name: row["name"], point: row["point"].to_i, password: row["password"]}
    end
  end

  def choose_product(products)
    # 商品番号の入力（複数可）
    while true
      print "ご購入の商品番号を入力してください。 > "
      product_num = gets.split(' ').map(&:to_i)
      if product_num.any?
        break if product_num.all? { |num| num.between?(1, products.length) }
      end
      puts "【！】入力した商品番号はありません。"
    end
    p product_num
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

  def disp_products
    # 商品を一覧表示
    puts "  ＜商品一覧＞"
    @products.each do |product|
      puts "#{product[:id]}:#{product[:name]} : #{product[:price]}円"
    end
  end

  def calculate_fee(chosen_product)
    @total_price = chosen_product.map { |num| @products[num - 1][:price] }
    puts "合計金額は#{@total_price.sum}円になります。 お買い上げありがとうございました!"
  end
end

customer = Customer.new
shop = Shop.new
products = shop.disp_products
chosen_product = customer.choose_product(products)
shop.calculate_fee(chosen_product)