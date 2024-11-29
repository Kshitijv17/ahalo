User.delete_all

User.create(email:"jil@gmail.com",password_digest:"1234")
User.create(email:"zil@gmail.com",password_digest:"1234")
User.create(email:"ail@gmail.com",password_digest:"1234")
User.create(email:"qil@gmail.com",password_digest:"1234")
User.create(email:"wil@gmail.com",password_digest:"1234")
User.create(email:"kshitijv17@gmail.com",password_digest:"1234")



Product.delete_all

product = [
  { name: "Smartphone X1000", stat: "active", cat: "electronics" },
  { name: "Wireless Headphones", stat: "active", cat: "electronics" },
  { name: "Gaming Laptop 15 Ultra", stat: "active", cat: "electronics" },
  { name: "Leather Wallet", stat: "inactive", cat: "accessories" },
  { name: "Fashion Sneakers", stat: "active", cat: "fashion" },
  { name: "Luxury Watch", stat: "active", cat: "fashion" },
  { name: "Bluetooth Speaker", stat: "inactive", cat: "electronics" },
  { name: "4K Smart TV", stat: "active", cat: "electronics" },
  { name: "Ergonomic Office Chair", stat: "active", cat: "home" },
  { name: "Organic Cotton Bed Sheets", stat: "inactive", cat: "home" }
]

product.each do |game|
  Product.create(game)
end

puts "products have been seeded!"
# AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?