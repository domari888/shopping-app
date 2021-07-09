require 'csv'
class Customer
  def initialize
    @lists = []
    CSV.foreach("customers.csv", headers: true) do |row|
      @lists << {id: row["id"].to_i, name: row["name"], point: row["point"].to_i, password: row["password"]}
    end
  end
end

class Shop
  def initialize
    @products = []
    CSV.foreach("products.csv", headers: true) do |row|
      @products << {name: row["name"], price: row["price"].to_i}
    end
  end

  def disp_products
    puts "  ＜商品一覧＞"
    @products.each.with_index(1) do |product, i|
      puts "#{i}:#{product[:name]} : #{product[:price]}円"
    end
  end
end

customer = Customer.new
shop = Shop.new
shop.disp_products
