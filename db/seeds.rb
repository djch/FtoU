# Products
# -----------------------------------------------------------------------------

products_data = [
  {
    title: "10 to 12 Inch Split Firewood",
    price: 130,
    unit: "bucket",
    available: true,
    description: "<div>Ideal for smaller or older fireboxes</div>"
  },
  {
    title: "12 to 15 Inch Split Firewood",
    price: 125,
    unit: "bucket",
    available: true,
    description: "<div>Most popular for larger fireplaces</div>"
  },
  {
    title: "Bagged Firewood",
    price: 120,
    unit: "bag",
    available: true,
    description: "<div>10KG bag of dried hardwood</div>"
  },
  {
    title: "Bagged Kindling",
    price: 120,
    unit: "bag",
    available: true,
    description: "<div>10KG bag of dried kindling<br>Lights quickly and easily to get your fire started</div>"
  },
  {
    title: "Bagged Sawdust",
    price: 120,
    unit: "bag",
    available: true,
    description: "<div>10KG bag of dried sawdust<br>Lights quickly and easily to get your fire started</div>"
  }
]

products_data.each do |product_data|
  next if Product.exists?(title: product_data[:title]) # Skip if the product exists already

  product = Product.create!(
    title: product_data[:title],
    price: product_data[:price],
    unit: product_data[:unit],
    available: product_data[:available]
  )
  product.description = product_data[:description] # Assigning rich text
  product.save!
end

# Customers & Orders
# -----------------------------------------------------------------------------

# Clear existing records
OrderItem.delete_all
Order.delete_all
Customer.delete_all

# Define the start date as 30 days ago from today
start_date = Date.today - 30.days

# Helper method to ensure delivery dates don't fall on weekends
def next_weekday(date)
  loop do
    date = date + 1.day
    break unless date.saturday? || date.sunday?
  end
  date
end

# Sample towns and postcodes from the Greater Hobart area of Tasmania
towns_and_postcodes = [
  { town: "Hobart", postcode: "7000" },
  { town: "Glenorchy", postcode: "7010" },
  { town: "Kingston", postcode: "7050" },
  { town: "Claremont", postcode: "7011" },
  { town: "Sandy Bay", postcode: "7005" },
  { town: "Bellerive", postcode: "7018" },
  { town: "Moonah", postcode: "7009" },
  { town: "Rosny Park", postcode: "7018" },
  { town: "Battery Point", postcode: "7004" },
  { town: "Blackmans Bay", postcode: "7052" },
  { town: "Lindisfarne", postcode: "7015" },
  { town: "Howrah", postcode: "7018" },
  { town: "Taroona", postcode: "7053" },
  { town: "South Hobart", postcode: "7004" },
  { town: "Mount Stuart", postcode: "7000" },
  { town: "West Hobart", postcode: "7000" },
  { town: "North Hobart", postcode: "7000" },
  { town: "Lenah Valley", postcode: "7008" },
  { town: "New Town", postcode: "7008" },
  { town: "Huonville", postcode: "7109" },
  { town: "Geeveston", postcode: "7116" }
]

# Iterate through a number of times to create customers
50.times do
  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name

  town_and_postcode = towns_and_postcodes.sample

  order_date = (start_date + rand(30).days) # Random date within last 30 days

  customer = Customer.create!(
    first_name: first_name,
    last_name: last_name,
    phone: "04#{Faker::Number.number(digits: 8)}",
    email: Faker::Internet.email(name: "#{first_name}_#{last_name}".downcase),
    street_address: "#{Faker::Number.number(digits: 3)} #{Faker::Address.street_name} St",
    town: town_and_postcode[:town],
    state: "TAS",
    postcode: town_and_postcode[:postcode],
    country: "Australia",
    delivery_notes: "Leave at the front door",
    created_at: order_date,
    updated_at: order_date
  )

  # Generate a single order for each customer
  delivery_date = order_date + rand(1..7).days
  delivery_date = next_weekday(delivery_date) if delivery_date.saturday? || delivery_date.sunday?

  order = customer.orders.create!(
    status: ['pending', 'confirmed', 'cancelled', 'delivered'].sample,
    delivery_date: delivery_date,
    created_at: order_date,
    updated_at: order_date,
    delivery_fee: [50, 55, 60, 65].sample,
    paid: [true, false].sample
  )

  # For each order, add between 1 to 3 unique order items
  products_for_this_order = Product.all.sample(rand(1..3))
  products_for_this_order.each do |product|
    order.order_items.create!(
      product: product,
      quantity: (1..5).to_a.sample,
      created_at: order_date,
      updated_at: order_date
    )
  end
end

